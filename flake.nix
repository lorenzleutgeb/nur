{
  description = "Lorenz Leutgeb's Flake";
  inputs = {
    # This looks redundant, but actually is nice.
    # Allows to model "stable" vs. "unstable" vs. "don't care".
    # Don't forget to also adjust the URL for home-manager below
    # accordingly.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs.follows = "nixpkgs-unstable";

    compat.url = "github:edolstra/flake-compat";
    hardware.url = "github:NixOS/nixos-hardware";
    hm = {
      url = "github:nix-community/home-manager/master";
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
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
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
        flake-compat.follows = "compat";
        flake-utils.follows = "utils";
        nixpkgs.follows = "nixpkgs";
      };
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        flake-compat.follows = "compat";
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
          ++ (lib.optional (name == "wsl") wsl.nixosModules.wsl) # https://github.com/nix-community/NixOS-WSL/pull/503/commits/ffdae0d9a6bb43f859c36d90091a85022fbcb5ce#diff-b6fcf40cf4716be824c72dac70c148d5664b3414f76a7a4433ac5573543523beR2
          ++ [
            (hmConfig ./hm "lorenz" name)
            {
              system.stateVersion = "23.11";
              system.configurationRevision =
                pkgs.lib.mkIf (self ? rev) self.rev;
              nix.registry = {
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
              zonecheck = {
                enable = true;
                name = "zonecheck";
                description = "Check DNS zones";
                files = "\\.zone$";
                entry = "${lib.getExe' pkgs.knot-dns "kzonecheck"} --verbose";
              };
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
