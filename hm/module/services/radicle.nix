{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    getBin
    getExe
    getExe'
    mapAttrsToList
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    ;

  inherit
    (lib.types)
    attrsOf
    nullOr
    oneOf
    package
    path
    str
    ;

  cfg = config.services.radicle;

  radicleHome = config.home.homeDirectory + "/.radicle";
in {
  options = {
    services.radicle = {
      enable = mkEnableOption "Radicle Services (Node and HTTP Daemon)";
      environment = mkOption {
        type = attrsOf (nullOr (oneOf [str path package]));
        default = {
          RUST_LOG = "info";
          RUST_BACKTRACE = "1";
        };
      };
      node = {
        args = mkOption {
          type = str;
          default = "--listen 0.0.0.0:8776";
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
    };
  };

  config = mkIf cfg.enable {
    systemd.user = {
      services = let
        common = x:
          mkMerge [
            x
            {
              Unit = {
                Documentation = ["https://radicle.xyz/guides"];
                After = ["default.target"];
                Requires = ["default.target"];
              };
              Service = {
                Environment = mapAttrsToList (name: value: "${name}=${value}") cfg.environment;
              };
            }
          ];
      in {
        "radicle-keys" = common {
          Unit = {
            Description = "Radicle Keys";
            Documentation = [
              "man:rad(1)"
              "https://radicle.xyz/guides/user#come-into-being-from-the-elliptic-aether"
            ];
          };
          Service = {
            Type = "oneshot";
            Slice = "background.slice";
            ExecStart = getExe (pkgs.writeShellApplication {
              name = "radicle-keys.sh";
              runtimeInputs = [pkgs.coreutils];
              text = let
                keyFile = name: "${radicleHome}/keys/${name}";
                keyPair = name: [(keyFile name) (keyFile (name + ".pub"))];
                radicleKeyPair = keyPair "radicle";
              in ''
                echo testing
                FILES=(${builtins.concatStringsSep " " radicleKeyPair})
                if stat --terse "''${FILES[@]}"
                then
                  # Happy path, we're done!
                  exit 0
                fi

                cat <<EOM
                At least one of the following files does not exist, but they all should!

                $(printf '  %s\n' "''${FILES[@]}")

                In order for Radicle to work, please initialize by executing

                  rad auth

                or provisioning pre-existing keys manually, e.g.

                  ln -s ~/.ssh/id_ed25519     ${keyFile "radicle"}
                  ln -s ~/.ssh/id_ed25519.pub ${keyFile "radicle.pub"}
                EOM
                exit 1
              '';
            });
          };
        };
        "radicle-httpd" = common {
          Unit = {
            Description = "Radicle HTTP Daemon";
            Documentation = ["man:radicle-httpd(1)"];
            After = ["radicle-node.service"];
            Requires = ["radicle-node.service"];
          };
          Service = {
            Slice = "session.slice";
            RestartSec = "1";
            ExecStart = "${getExe' cfg.httpd.package "radicle-httpd"} ${cfg.httpd.args}";
            Environment = ["PATH=${getBin config.programs.git.package}/bin"];
            KillMode = "process";
            Restart = "always";
          };
        };
        "radicle-node" = common {
          Unit = {
            Description = "Radicle Node";
            Documentation = ["man:radicle-node(1)"];
            After = ["radicle-keys.service"];
            Requires = ["radicle-keys.service"];
          };
          Service = {
            Slice = "session.slice";
            RestartSec = "3";
            ExecStart = "${getExe' cfg.node.package "radicle-node"} ${cfg.node.args}";
            Environment = ["PATH=${getBin config.programs.git.package}/bin"];
            KillMode = "process";
            Restart = "always";
          };
        };
      };
      sockets."radicle-node" = {
        Unit = {
          Description = "Radicle Node Control Socket";
          Documentation = ["man:radicle-node(1)"];
        };
        Socket.ListenStream = "${radicleHome}/node/control.sock";
        Install.WantedBy = ["sockets.target"];
      };
    };
    programs.radicle.enable = mkDefault true;
  };
}
