{
  description = "Lorenz Leutgeb's Flake";
  inputs = {
    # This looks redundant, but actually is nice.
    # Allows to model "stable" vs. "unstable" vs. "don't care".
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.follows = "nixpkgs";

    hardware = {
      url = "github:NixOS/nixos-hardware";
      flake = false;
    };
    hm = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "utils";
      };
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sbt = {
      url = "github:zaninime/sbt-derivation";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "utils";
      };
    };
    sops = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:numtide/flake-utils";
    vscode-server = {
      url = "github:Ten0/nixos-vscode-server";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "utils";
      };
    };
    wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "utils";
      };
    };
    radicle = {
      url = "git+https://seed.radicle.xyz/z3gqcJUoA1n9HaHKufZs5FCSGazv5.git?tag=v1.0.0-rc.8";
      #url = "path:/home/lorenz/src/rad/heartwood";
      inputs = {
        flake-utils.follows = "utils";
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        flake-utils.follows = "utils";
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs-stable";
      };
    };
  };

  outputs = inputs @ {
    self,
    hardware,
    hm,
    nixpkgs,
    nixpkgs-unstable,
    nix-index-database,
    pre-commit-hooks,
    sops,
    vscode-server,
    wsl,
    ...
  }: let
    lib = nixpkgs.lib.recursiveUpdate nixpkgs.lib (import ./lib.nix {inherit (nixpkgs) lib;});

    inherit
      (lib)
      attrValues
      dirToAttrs
      nameValuePair
      mapAttrs
      mapAttrs'
      ;

    inherit
      (builtins)
      readDir
      ;

    system = "x86_64-linux";

    modules = {
      input = [
        nixpkgs.nixosModules.notDetected
        hm.nixosModules.home-manager
        sops.nixosModules.sops
        wsl.nixosModules.wsl
      ];
      self = attrValues self.nixosModules;
    };

    homeModules = {
      input = [
        vscode-server.homeModules.default
        nix-index-database.hmModules.nix-index
        sops.homeManagerModule
      ];
      self = {
        "programs.radicle" = ./hm/module/programs/radicle.nix;
        "services.radicle" = ./hm/module/services/radicle.nix;
        "services.ulauncher" = ./hm/module/services/ulauncher.nix;
      };
    };

    pkgs = import nixpkgs {
      inherit system;
      overlays = attrValues self.overlays;
    };

    importPackages = pkgs:
      import ./pkg {
        inherit (pkgs) newScope;
      };

    hmConfig = path: user: host: let
      hm = import path;
    in
      if hm ? ${host}
      then {
        home-manager = {
          users.${user}.imports =
            hm.${host}
            ++ homeModules.input
            ++ (attrValues homeModules.self);

          useGlobalPkgs = true;
          useUserPackages = false;
          backupFileExtension = "bak";
          extraSpecialArgs = {
            inherit inputs self;
          };
        };
      }
      else {};

    host = name: preconfig: let
      result = lib.nixosSystem {
        specialArgs = {
          inherit hardware self inputs;
          lib =
            lib
            // (import ./os/lib {
              inherit lib;
              inherit (result) config;
            });
        };
        modules =
          modules.input
          ++ [
            (hmConfig ./hm "lorenz" name)
            {
              system.stateVersion = "20.03";
              system.configurationRevision =
                pkgs.lib.mkIf (self ? rev) self.rev;
              nix.registry = {
                nixpkgs = {
                  from = {
                    id = "nixpkgs";
                    type = "indirect";
                  };
                  flake = nixpkgs;
                };
                nixpkgs-unstable = {
                  from = {
                    id = "nixpkgs-unstable";
                    type = "indirect";
                  };
                  flake = nixpkgs-unstable;
                };
              };
              nixpkgs = {
                overlays = attrValues self.overlays;
                config.allowUnfree = true;
              };
            }
            preconfig
          ]
          ++ modules.self;
      };
    in
      result;
  in
    rec {
      overlays = {default = final: prev: importPackages prev;} // (mapAttrs (_: v: import v inputs) (dirToAttrs ./overlay));

      packages.${system} =
        importPackages pkgs
        // {
          nc = import "${nixpkgs}/nixos/lib/make-disk-image.nix" {
            inherit pkgs;
            inherit (pkgs) lib;
            diskSize = "auto"; # 240 * 1000 * 1000 * 1000; # 240GB
            format = "qcow2";
            config = nixosConfigurations.nc.config;
          };
          live = nixosConfigurations.live.config.system.build.isoImage;
          #wsl = nixosConfigurations.wsl.config.system.build.tarball;
        };

      packages."aarch64-linux".pi-sd =
        (host "pi" ({modulesPath, ...}: {
          imports = [./os/host/pi "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"];
        }))
        .config
        .system
        .build
        .sdImage;

      nixosModules = mapAttrs (_: import) (dirToAttrs ./os/module);

      nixosConfigurations = let dir = ./os/host; in mapAttrs (id: _: host id (import (dir + "/${id}"))) (readDir dir);

      devShell.${system} = pkgs.mkShell {
        inherit (self.checks.${system}.pre-commit) shellHook;
        buildInputs = self.checks.${system}.pre-commit.enabledPackages;
      };

      formatter.${system} = pkgs.writeShellApplication {
        name = "formatter";
        text = ''
          # shellcheck disable=all
          shell-hook () {
            ${self.checks.${system}.pre-commit.shellHook}
          }

          shell-hook
          pre-commit run --all-files
        '';
      };

      checks.${system} =
        {
          pre-commit = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              alejandra.enable = true;
            };
          };
        }
        // (mapAttrs' (name: value: nameValuePair "packages/${name}" value) self.packages.${system})
        // (mapAttrs' (name: value: nameValuePair "nixosConfigurations/${name}" value.config.system.build.toplevel) self.nixosConfigurations);

      /*
      homeConfigurations = mapAttrs (_: config:
        hm.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = {inherit inputs;};
          modules =
            [
              config
              vscode-server.homeModules.default
              nix-index-database.hmModules.nix-index
            ]
            ++ (attrValues (importDirToAttrs ./hm/module));
        }) (import ./hm);
      */
    }
    // {
      homeModules = homeModules.self;
    };
}
