{
  description = "Lorenz Leutgeb's Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-20.09";
    nixpkgsUnstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-20.09";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Modules
    hardware = {
      url = "github:NixOS/nixos-hardware";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixpkgsUnstable, ... }:
    with builtins;
    with nixpkgs;

    let
      system = "x86_64-linux";
      pkgsUnstable = import nixpkgsUnstable {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs = import nixpkgs {
        inherit system;
        overlays = builtins.attrValues self.overlays;
        config.allowUnfree = true;
      };
    in {
      /* nixosConfigurations."1anm3dk20fd60zb66cv7callrv82gn2z2jjlkqdbbb0i877hh872" = nixpkgs.lib.nixosSystem {
           inherit system;
           modules = [
             (import ./configuration.nix) pkgs
             ./hardware/1anm3dk20fd60zb66cv7callrv82gn2z2jjlkqdbbb0i877hh872.nix
           ];
         };
      */

      overlay = self.overlays.pkgs;
      overlays = {
        pkgs = import ./pkg;
      } // self.lib.importDirToAttrs ./overlay;

      packages.${system} = {
        inherit (pkgs) kmonad-bin talon-bin;
        inherit (pkgs.nodePackages) firebase-tools turtle-validator;
      };

      nixosModules = self.lib.importDirToAttrs ./os/module;

      nixosConfigurations =
        pkgs.lib.mapAttrs (id: _: self.lib.nixosSystemFor id { })
        (builtins.readDir ./os/host);

      lib = rec {
        kebabCaseToCamelCase =
          replaceStrings (map (s: "-${s}") lib.lowerChars) lib.upperChars;

        importDirToAttrs = dir:
          listToAttrs (map (name: {
            name = kebabCaseToCamelCase (lib.removeSuffix ".nix" name);
            value = import (dir + "/${name}");
          }) (attrNames (readDir dir)));

        nixosSystemFor = let
          specialArgs = {
            inherit (self.inputs) hardware;
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
                    ]; # ++ (attrValues self.homeManagerModules);
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
            home
            common
            local
          ] ++ (pkgs.lib.attrValues self.nixosModules) ++ extraModules;
        };
      };
    };
}
