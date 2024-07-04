{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    getBin
    getExe'
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    ;

  inherit
    (lib.types)
    attrsOf
    bool
    enum
    ints
    listOf
    nullOr
    oneOf
    package
    path
    str
    submodule
    ;

  cfg = config.services.radicle;

  configFile = rec {
    format = pkgs.formats.json {};
    name = "config.json";
    path =
      pkgs.runCommand name {
        nativeBuildInputs = [cfg.cli.package];
      } ''
          mkdir keys
          echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDCLaw/LP2QyqhljkjIuJ6TWICR6XP2Wj4h3oxBO0076 radicle" \
            > keys/radicle.pub
          cp ${format.generate name cfg.settings} ${name}
        RAD_HOME=$PWD rad config
          cp ${name} $out
      '';
  };

  freeform = options:
    mkOption {
      default = {};
      type = submodule {
        inherit options;
        freeformType = configFile.format.type;
      };
    };
in {
  options = {
    services.radicle = {
      enable = mkEnableOption "Radicle Seed Node";
      package = mkPackageOption pkgs "radicle-full" {};
      environment = mkOption {
        type = attrsOf (nullOr (oneOf [str path package]));
        default = {
          RUST_LOG = "info";
          RUST_BACKTRACE = "1";
          RAD_HOME = "/var/lib/radicle";
        };
      };
      cli = {
        package = mkPackageOption pkgs "radicle-cli" {};
      };
      node = {
        args = mkOption {
          type = str;
          default = "--listen 0.0.0.0:8776 --force";
        };
        keyFile = mkOption {
          type = str;
          default = "/run/secrets/ssh/key";
        };
        package = mkPackageOption pkgs "radicle-node" {};
      };
      httpd = {
        args = mkOption {
          type = str;
          default = "--listen 127.0.0.1:8080";
        };
        package = mkPackageOption pkgs "radicle-httpd" {};
      };
      settings = freeform {
        publicExplorer = mkOption {
          type = str;
          default = "https://app.radicle.xyz/nodes/$host/$rid$path";
        };
        preferredSeeds = mkOption {
          type = listOf str;
          default = [
            "z6MkrLMMsiPWUcNPHcRajuMi9mDfYckSoJyPwwnknocNYPm7@seed.radicle.garden:8776"
            "z6Mkmqogy2qEM2ummccUthFEaaHvyYmYBYh3dbe9W4ebScxo@ash.radicle.garden:8776"
          ];
        };
        web = freeform {
          pinned = freeform {
            repositories = mkOption {
              type = listOf str;
              default = [];
            };
          };
        };
        cli = freeform {
          hints = mkOption {
            type = bool;
            default = true;
          };
        };
        node = freeform {
          alias = mkOption {
            type = str;
            default = config.home.username;
          };
          network = mkOption {
            type = str;
            default = "main";
          };
          relay = mkOption {
            type = bool;
            default = true;
          };
          peers = freeform {
            type = mkOption {
              type = enum ["static" "dynamic"];
              default = "dynamic";
            };
            target = mkOption {
              type = ints.unsigned;
              default = 8;
            };
          };
          workers = mkOption {
            type = ints.unsigned;
            default = 8;
          };
          policy = mkOption {
            type = enum ["allow" "block"];
            default = "block";
          };
          scope = mkOption {
            type = enum ["all" "followed"];
            default = "all";
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
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
          ExecStart = "${getBin cfg.httpd.package}/bin/radicle-httpd ${cfg.httpd.args}";
        };
      };
      "radicle-node" = common {
        description = "Radicle Node";
        documentation = [
          "man:radicle-node(1)"
        ];
        serviceConfig = {
          RestartSec = "3";
          LoadCredential = ["radicle:${cfg.node.keyFile}"];
          ExecStartPre = "${getExe' pkgs.coreutils "ln"} --symbolic --force \${CREDENTIALS_DIRECTORY}/radicle \${STATE_DIRECTORY}/keys/radicle";
          ExecStart = "${getBin cfg.node.package}/bin/radicle-node --config /etc/${config.environment.etc."radicle/${configFile.name}".target} ${cfg.node.args}";
        };
      };
      /*
           "radicle-keys" = {
             description = "Radicle Node Key Setup";
      serviceConfig = {
        Type = "oneshot";
      };
      script = ''
      '';
           };
      */
    };

    environment = {
      etc."radicle/${configFile.name}".source = configFile.path;
      systemPackages = [cfg.cli.package];
    };

    users.users.radicle = {
      isSystemUser = true;
      group = "radicle";
    };
    users.groups.radicle = {};
  };
}
