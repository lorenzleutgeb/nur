{
  description = "Lorenz Leutgeb's Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Modules
    hardware = {
      url = "github:NixOS/nixos-hardware";
      flake = false;
    };

    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server = {
      url = "github:msteen/nixos-vscode-server";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, simple-nixos-mailserver
    , vscode-server, ... }:
    with builtins;
    with nixpkgs;

    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = builtins.attrValues self.overlays;
        config.allowUnfree = true;
        #config.allowBroken = true;
      };
      makeDiskImage = (import "${nixpkgs}/nixos/lib/make-disk-image.nix");
    in rec {
      overlay = self.overlays.pkgs;
      overlays = {
        pkgs = import ./pkg;
      } // self.util.importDirToAttrs ./overlay;

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

        mpi = nixosConfigurations.mpi.config.system.build.virtualBoxOVA;

        live = nixosConfigurations.live.config.system.build.isoImage;
      };

      nixosModules = self.util.importDirToAttrs ./os/module;
      homeManagerModules = self.util.importDirToAttrs ./home-manager/module;

      nixosConfigurations =
        ((pkgs.lib.mapAttrs (id: _: self.util.nixosSystemFor id { })
          (builtins.readDir ./os/host))) // {
            live = lib.nixosSystem {
              inherit system;
              modules = [
                "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
                { boot.kernelPackages = pkgs.linuxPackages_5_14; }
              ];
            };
          };

      util = rec {
        kebabCaseToCamelCase =
          replaceStrings (map (s: "-${s}") lib.lowerChars) lib.upperChars;

        importDirToAttrs = dir:
          listToAttrs (map (name: {
            name = kebabCaseToCamelCase (lib.removeSuffix ".nix" name);
            value = import (dir + "/${name}");
          }) (attrNames (readDir dir)));

        nixosSystemFor = let
          specialArgs = {
            inherit (self.inputs) hardware nixpkgs;
            # profiles = self.lib.importDirToAttrs ./nixos/profiles;
          };
        in id:
        { extraModules ? [ ], ... }@args:
        lib.nixosSystem {
          inherit system specialArgs;

          modules = let
            home = { config, ... }: {
              options.home-manager.users = lib.mkOption {
                type = with lib.types;
                  attrsOf (submoduleWith {
                    specialArgs = specialArgs // {
                      super = config;
                      # profiles = self.lib.importDirToAttrs ./home-manager/profiles;
                    };
                    modules = [
                      # emacs-config.homeManagerModules.emacsConfig
                      # "${vsliveshare}/modules/vsliveshare/home.nix"
                      "${vscode-server}/modules/vscode-server/home.nix"
                    ] ++ (builtins.attrValues self.homeManagerModules);
                  });
              };

              config = {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = false;
                  backupFileExtension = "bak";
                };
              };
            };
            common = {
              system.stateVersion = "20.03";
              system.configurationRevision =
                pkgs.lib.mkIf (self ? rev) self.rev;
              nixpkgs = { inherit pkgs; };
              nix.registry.nixpkgs.flake = nixpkgs;
            };
            local = import (./os/host + "/${id}");
          in [
            nixpkgs.nixosModules.notDetected
            home-manager.nixosModules.home-manager
            simple-nixos-mailserver.nixosModule
            home
            common
            local
          ] ++ (pkgs.lib.attrValues self.nixosModules) ++ extraModules;
        };
      };
    };
}
