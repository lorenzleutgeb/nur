{
  description = "Lorenz Leutgeb's Flake";
  inputs = {
    hardware = {
      url = "github:NixOS/nixos-hardware";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server = {
      url = "github:msteen/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, home-manager, nixpkgs, nix-index-database, sops, vscode-server, wsl, ... }:
    with builtins;
    with nixpkgs;

    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = builtins.attrValues self.overlays;
        config.allowUnfree = true;
      };
      makeDiskImage = (import "${nixpkgs}/nixos/lib/make-disk-image.nix");

      kebabCaseToCamelCase =
        replaceStrings (map (s: "-${s}") lib.lowerChars) lib.upperChars;

      importDirToAttrs = dir:
        listToAttrs (map (name: {
          name = kebabCaseToCamelCase (lib.removeSuffix ".nix" name);
          value = import (dir + "/${name}");
        }) (attrNames (readDir dir)));

      nixosSystemFor = preconfig:
        lib.nixosSystem {
          inherit system;

          modules = let
            home = { config, ... }: {
              options.home-manager.users = lib.mkOption {
                type = with lib.types;
                  attrsOf (submoduleWith {
                    specialArgs = { super = config; };
                    modules = [
                      vscode-server.homeModules.default
                      nix-index-database.hmModules.nix-index
                    ] ++ (builtins.attrValues (importDirToAttrs ./hm/module));
                  });
              };

              config.home-manager = {
                useGlobalPkgs = true;
                useUserPackages = false;
                backupFileExtension = "bak";
                extraSpecialArgs.inputs = inputs;
              };
            };
            common = {
              system.stateVersion = "20.03";
              system.configurationRevision =
                pkgs.lib.mkIf (self ? rev) self.rev;
              #nixpkgs = { inherit pkgs; };
              #nix.registry.nixpkgs.flake = nixpkgs;
            };
          in [
            nixpkgs.nixosModules.notDetected
            home-manager.nixosModules.home-manager
            sops.nixosModules.sops
            wsl.nixosModules.wsl
            home
            common
            preconfig
          ];
        };

    in rec {
      overlays = { pkgs = import ./pkg; } // importDirToAttrs ./overlay;

      packages.${system} = {
        inherit (pkgs) kmonad-bin;
        inherit (pkgs.nodePackages) firebase-tools; # turtle-validator;

        nc = makeDiskImage {
          inherit pkgs;
          inherit (pkgs) lib;
          diskSize = "auto"; # 240 * 1000 * 1000 * 1000; # 240GB
          format = "qcow2";
          config = nixosConfigurations.nc.config;
        };
        live = nixosConfigurations.live.config.system.build.isoImage;
        wsl = nixosConfigurations.wsl.config.system.build.installer;
      };

      nixosModules = importDirToAttrs ./os/module;

      nixosConfigurations =
        ((mapAttrs (id: _: nixosSystemFor (import (./os/host + "/${id}")))
          (readDir ./os/host))) // {
            live = lib.nixosSystem {
              inherit system;
              modules = [
                "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
              ];
            };
          };

      formatter.${system} = pkgs.alejandra;
    };
}
