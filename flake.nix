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
    ngipkgs = {
      url = "github:ngi-nix/ngipkgs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "utils";
        sops-nix.follows = "sops";
      };
    };
    nil = {
      url = "github:oxalica/nil";
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
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:numtide/flake-utils";
    vscode-server = {
      url = "github:msteen/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mailserver = {
      url = "git+https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/";
      inputs = {
        utils.follows = "utils";
        nixpkgs.follows = "nixpkgs";
        nixpkgs-23_05.follows = "nixpkgs";
      };
    };
  };

  outputs = inputs @ {
    self,
    home-manager,
    mailserver,
    ngipkgs,
    nil,
    nixpkgs,
    nix-index-database,
    sops,
    treefmt-nix,
    vscode-server,
    wsl,
    ...
  }:
    with builtins;
    with nixpkgs; let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = (attrValues self.overlays) ++ [(_: _: {inherit (nil.packages.${system}) nil;})];
        config.allowUnfree = true;
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

      hm = import ./hm;

      host = name: preconfig:
        lib.nixosSystem {
          modules = let
            home =
              if hm ? ${name}
              then {
                home-manager = {
                  users.lorenz.imports =
                    hm.${name}
                    ++ [
                      vscode-server.homeModules.default
                      nix-index-database.hmModules.nix-index
                      sops.homeManagerModule
                    ]
                    ++ (attrValues (importDirToAttrs ./hm/module));

                  useGlobalPkgs = true;
                  useUserPackages = false;
                  backupFileExtension = "bak";
                  extraSpecialArgs.inputs = inputs;
                };
              }
              else {};
            common = {
              system.stateVersion = "20.03";
              system.configurationRevision =
                pkgs.lib.mkIf (self ? rev) self.rev;
              nix.registry.nixpkgs = {
                from = {
                  id = "nixpkgs";
                  type = "indirect";
                };
                flake = nixpkgs;
              };
            };
          in [
            nixpkgs.nixosModules.notDetected
            home-manager.nixosModules.home-manager
            mailserver.nixosModules.default
            sops.nixosModules.sops
            wsl.nixosModules.wsl
            ngipkgs.nixosModules.default
            home
            common
            preconfig
          ];
        };
    in rec {
      overlays = {default = import ./pkg;} // importDirToAttrs ./overlay;

      formatter.${system} = treefmt.config.build.wrapper;

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

      nixosConfigurations = let dir = ./os/host; in mapAttrs (id: _: host id (import (dir + "/${id}"))) (readDir dir);

      checks.${system} =
        self.packages.${system}
        // {
          formatting = treefmt.config.build.check self;
        };

      /*
      homeConfigurations = mapAttrs (_: config:
        home-manager.lib.homeManagerConfiguration {
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
