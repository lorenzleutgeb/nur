{
  description = "Lorenz Leutgeb's Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server = {
      url = "github:msteen/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hardware = {
      url = "github:NixOS/nixos-hardware";
      flake = false;
    };
    mpi-klsb-known-hosts = {
      url = "https://ca.mpi-klsb.mpg.de/ssh_known_hosts";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, vscode-server, wsl, ... }:
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

      nixosSystemFor = let
        specialArgs = ;
      in preconfig:
      lib.nixosSystem {
        inherit system specialArgs;

        modules = let
          home = { config, ... }: {
            options.home-manager.users = lib.mkOption {
              type = with lib.types;
                attrsOf (submoduleWith {
                  specialArgs = specialArgs // {
                    inputs = inputs;
                    super = config;
                  };
                  modules = [
                    "${vscode-server}/modules/vscode-server/home.nix"
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
            system.configurationRevision = pkgs.lib.mkIf (self ? rev) self.rev;
            nixpkgs = { inherit pkgs; };
            nix.registry.nixpkgs.flake = nixpkgs;
          };
        in [
          nixpkgs.nixosModules.notDetected
          home-manager.nixosModules.home-manager
          wsl.nixosModules.wsl
          home
          common
          preconfig
        ] ++ (pkgs.lib.attrValues self.nixosModules);
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
    };
}
