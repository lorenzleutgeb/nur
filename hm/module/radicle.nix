{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.radicle;
  settingsFormat = pkgs.formats.json {};
  home = config.home.homeDirectory + "/.radicle";
  mkMerge' = x: y: lib.mkMerge [x y];
in {
  options = {
    services.radicle = {
      enable = mkEnableOption "Radicle";

      environment = mkOption {
        type = with types; attrsOf (nullOr (oneOf [str path package]));
        default = {
          RUST_LOG = "info";
          RUST_BACKTRACE = "1";
        };
      };

      node = {
        args = lib.mkOption {
          type = lib.types.str;
          default = "--listen 0.0.0.0:8776 --force";
        };
        package = lib.mkPackageOption pkgs "radicle-node" {};
      };

      httpd = {
        args = lib.mkOption {
          type = lib.types.str;
          default = "--listen 127.0.0.1:8080";
        };
        package = lib.mkPackageOption pkgs "radicle-httpd" {};
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = settingsFormat.type;
        };
        default = {
          publicExplorer = "https://app.radicle.xyz/nodes/$host/$rid$path";
          preferredSeeds = [
            "z6MkrLMMsiPWUcNPHcRajuMi9mDfYckSoJyPwwnknocNYPm7@seed.radicle.garden:8776"
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
            alias = config.home.username;
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

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [radicle-cli radicle-remote-helper];
      file.".radicle/config.json".source = settingsFormat.generate "radicle-config.json" cfg.settings;
    };

    programs.git.enable = true;

    services.ssh-agent.enable = lib.mkDefault true;

    systemd.user = {
      services = let
        common = mkMerge' {
          Unit = {
            Documentation = ["https://radicle.xyz/guides"];
            After = ["default.target"];
            Requires = ["default.target"];
          };
          Service = {
            Environment = lib.mapAttrsToList (name: value: "radicle=${value}") cfg.environment;
          };
        };
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
            ExecStart = lib.getExe (pkgs.writeShellApplication {
              name = "radicle-keys.sh";
              runtimeInputs = [pkgs.coreutils];
              text = let
                keyFile = name: home + "/keys/" + name;
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
            ExecStart = "${lib.getExe' cfg.httpd.package "radicle-httpd"} ${cfg.httpd.args}";
            Environment = ["PATH=${lib.getBin config.programs.git.package}/bin"];
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
            ExecStart = "${lib.getExe' cfg.node.package "radicle-node"} ${cfg.node.args}";
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
        Socket.ListenStream = home + "/node/control.sock";
        Install.WantedBy = ["sockets.target"];
      };
    };
  };
}
