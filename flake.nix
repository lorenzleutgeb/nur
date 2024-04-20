{
  description = "Lorenz Leutgeb's Flake";
  inputs = {
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
    nil = {
      url = "github:oxalica/nil";
      #inputs.nixpkgs.follows = "nixpkgs"; Stopped following nixpkgs since nil's Rust version is too far ahead.
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
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
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:numtide/flake-utils";
    vscode-server = {
      # See https://github.com/nix-community/nixos-vscode-server/pull/78
      url = "github:Ten0/nixos-vscode-server/support_new_vscode_versions";
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
    mailserver = {
      url = "git+https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/";
      inputs = {
        utils.follows = "utils";
        nixpkgs.follows = "nixpkgs";
      };
    };
    radicle = {
      url = "github:radicle-dev/heartwood/v1.0.0-rc.4";
      inputs = {
        flake-utils.follows = "utils";
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };
  };

  outputs = inputs @ {
    self,
    hardware,
    hm,
    mailserver,
    nil,
    nixpkgs,
    nixpkgs-unstable,
    nix-index-database,
    sbt,
    sops,
    treefmt-nix,
    vscode-server,
    wsl,
    ...
  }:
    with builtins;
    with nixpkgs; let
      system = "x86_64-linux";
      overlays = {
        # Overlays defined in flake inputs.
        input = [
          sbt.overlays.default
          (_: _: {inherit (nil.packages.${system}) nil;})
          (_: _: inputs.radicle.packages.${system})
        ];
        # Overlays that are outputs of self;
        self = attrValues self.overlays;
      };

      modules = {
        input = [
          nixpkgs.nixosModules.notDetected
          hm.nixosModules.home-manager
          #mailserver.nixosModules.default
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
        self = attrValues (importDirToAttrs ./hm/module);
      };

      pkgs = import nixpkgs {
        inherit system;
        overlays = overlays.input ++ overlays.self;
      };

      importPackages = pkgs:
        import ./pkg {
          inherit (pkgs) newScope;
        };

      makeDiskImage = import "${nixpkgs}/nixos/lib/make-disk-image.nix";

      kebabCaseToCamelCase =
        replaceStrings (map (s: "-${s}") lib.lowerChars) lib.upperChars;

      importDirToAttrs = dir:
        listToAttrs (map (name: {
          name = kebabCaseToCamelCase (lib.removeSuffix ".nix" name);
          value = import (dir + "/${name}");
        }) (attrNames (readDir dir)));

      treefmt = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;

      hmConfig = path: user: host: let
        hm = import path;
      in
        if hm ? ${host}
        then {
          home-manager = {
            users.${user}.imports =
              hm.${host}
              ++ homeModules.input
              ++ homeModules.self;

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
            inherit hardware self;
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
                  overlays = overlays.input ++ overlays.self;
                  config.allowUnfree = true;
                };
              }
              preconfig
            ]
            ++ modules.self;
        };
      in
        result;
    in rec {
      overlays = {default = final: prev: importPackages prev;} // importDirToAttrs ./overlay;

      formatter.${system} = treefmt.config.build.wrapper;

      packages.${system} =
        importPackages pkgs
        // {
          nc = makeDiskImage {
            inherit pkgs;
            inherit (pkgs) lib;
            diskSize = "auto"; # 240 * 1000 * 1000 * 1000; # 240GB
            format = "qcow2";
            config = nixosConfigurations.nc.config;
          };
          live = nixosConfigurations.live.config.system.build.isoImage;
          wsl = nixosConfigurations.wsl.config.system.build.tarball;
        };

      packages."aarch64-linux".pi-sd =
        (host "pi" ({modulesPath, ...}: {
          imports = [./os/host/pi "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"];
        }))
        .config
        .system
        .build
        .sdImage;

      nixosModules = importDirToAttrs ./os/module;

      nixosConfigurations = let dir = ./os/host; in mapAttrs (id: _: host id (import (dir + "/${id}"))) (readDir dir);

      checks.${system} =
        self.packages.${system}
        // {
          formatting = treefmt.config.build.check self;
        };

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
    };
}
