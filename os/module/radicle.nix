{
  config,
  lib,
  pkgs,
  ...
}:
with pkgs;
with lib; let
  cfg = config.services.radicle;
  getExe = lib.getExe' cfg.package;
  settings = {
    format = pkgs.formats.json {};
    name = "radicle.json";
  };
in {
  options = {
    services.radicle = {
      enable = mkEnableOption "Radicle";
      package = mkPackageOption pkgs "radicle-full" {};
      keyFile = mkOption {
        type = types.str;
        default = "/run/secrets/ssh/key";
      };
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
          default = "--listen 0.0.0.0:8776 --force";
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
          options = {
            publicExplorer = lib.mkOption {
              type = lib.types.str;
              default = "https://app.radicle.xyz/nodes/$host/$rid$path";
            };
            preferredSeeds = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [
                "z6MkrLMMsiPWUcNPHcRajuMi9mDfYckSoJyPwwnknocNYPm7@seed.radicle.garden:8776"
              ];
            };

            node = mkOption {
              type = types.submodule {
                options = {
                  alias = mkOption {
                    type = lib.types.str;
                    default = config.networking.hostName;
                  };
                  network = mkOption {
                    type = lib.types.str;
                    default = "main";
                  };
                  relay = mkOption {
                    type = lib.types.bool;
                    default = true;
                  };
                  workers = mkOption {
                    type = lib.types.int;
                    default = 8;
                  };

                  policy = mkOption {
                    type = lib.types.str;
                    default = "block";
                  };

                  scope = mkOption {
                    type = lib.types.str;
                    default = "all";
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.radicle = {
      isSystemUser = true;
      group = "radicle";
    };
    users.groups.radicle = {};

    environment.systemPackages = [pkgs.radicle-cli pkgs.radicle-remote-helper pkgs.radicle-full];

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
          User = "radicle";
          KillMode = "process";
          Restart = "always";
          StateDirectory = "radicle";
        };
      };
    in {
      "radicle-httpd" = common {
        description = "Radicle HTTP Daemon";
        documentation = [
          "man:radicle-httpd(1)"
        ];
        serviceConfig = {
          RestartSec = "1";
          ExecStart = "${getExe "radicle-httpd"} ${cfg.httpd.args}";
        };
      };
      "radicle-node" = common {
        description = "Radicle Node";
        documentation = [
          "man:radicle-node(1)"
        ];
        serviceConfig = {
          RestartSec = "3";
          # TODO: Credentials.
          #ExecStartPre = "${lib.getExe' pkgs.coreutils "ln"} --symbolic --force \${CREDENTIALS_DIRECTORY}/radicle \${STATE_DIRECTORY}/keys/radicle";
          ExecStart = "${getExe "radicle-node"} --config /etc/${config.environment.etc.${settings.name}.target} ${cfg.node.args}";
          #LoadCredential = [ "radicle:${cfg.keyFile}" ];
        };
      };
    };
  };
}
