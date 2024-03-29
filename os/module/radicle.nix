{
  config,
  lib,
  pkgs,
  ...
}:
with pkgs;
with lib; let
  name = "radicle";
  cfg = config.services.${name};
  getExe = lib.getExe' cfg.package;
  settings = {
    format = pkgs.formats.json {};
    name = "${name}.json" ;
  };
in {
  options = {
    services.${name} = {
      enable = mkEnableOption "Radicle";
      package = mkPackageOption pkgs "radicle-full" {};
      environment = mkOption {
        type = with types; attrsOf (nullOr (oneOf [str path package]));
        default = {
          RUST_LOG = "info";
          RUST_BACKTRACE = "1";
          RAD_HOME = "/var/lib/radicle";
        };
      };
      node = {
        args = lib.mkOption {
          type = lib.types.str;
          default = "--listen 0.0.0.0:8080";
        };
      };
      httpd = {
        args = lib.mkOption {
          type = lib.types.str;
          default = "--listen 127.0.0.1:8080";
        };
      };
      settings = lib.mkOption {
        type = lib.types.submodule {
          # Declare that the settings option supports arbitrary format values, json here
          freeformType = settings.format.type;
        };
        default = {
          publicExplorer = "https://app.radicle.xyz/nodes/$host/$rid$path";
          preferredSeeds = [
            #"z6MkrLMMsiPWUcNPHcRajuMi9mDfYckSoJyPwwnknocNYPm7@seed.radicle.garden:8776"
            "z6MkjDYUKMUeY58Vtr8dGJrHRvnTfjKWVGCBYJDVTHXsXzm5@seed.radicle.at:8776"
          ];
          web = {
            pinned = {
              repositories = [];
            };
          };
          cli = {
            hints = true;
          };
          node = {
            #alias = config.networking.hostName;
            alias = "leutgeb.xyz";
            listen = [];
            peers = {
              type = "dynamic";
              target = 8;
            };
            connect = [];
            externalAddresses = [];
            network = "main";
            relay = true;
            limits = {
              routingMaxSize = 1000;
              routingMaxAge = 604800;
              gossipMaxAge = 1209600;
              fetchConcurrency = 1;
              maxOpenFiles = 4096;
              rate = {
                inbound = {
                  fillRate = 0.2;
                  capacity = 32;
                };
                outbound = {
                  fillRate = 1.0;
                  capacity = 64;
                };
              };
              connection = {
                inbound = 128;
                outbound = 16;
              };
            };
            workers = 8;
            policy = "block";
            scope = "all";
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.radicle-cli pkgs.radicle-remote-helper];

    environment.etc.${settings.name}.source = settings.format.generate settings.name cfg.settings;

    systemd.services = let
      common = lib.recursiveUpdate {
        inherit (cfg) environment;
        path = [pkgs.git];
        documentation = [
          "https://docs.radicle.xyz/guides/seeder"
        ];
        after = ["network.target" "network-online.target"];
        requires = ["network-online.target"];
        serviceConfig = {
          DynamicUser = "yes";
          User = name;
          KillMode = "process";
          Restart = "always";
          StateDirectory = "radicle";
        };
      };
    in {
      "${name}-httpd" = common {
        description = "Radicle HTTP Daemon";
        documentation = [
          "man:radicle-httpd(1)"
        ];
        serviceConfig = {
          RestartSec = "1";
          ExecStart = "${getExe "radicle-httpd"} ${cfg.httpd.args}";
        };
      };
      "${name}-node" = common {
        description = "Radicle Node";
        documentation = [
          "man:radicle-node(1)"
        ];
        serviceConfig = {
          RestartSec = "3";
          ExecStart = "${getExe "radicle-node"} --config /etc/${config.environment.etc.${settings.name}.target} ${cfg.node.args}";
        };
      };
    };
  };
}
