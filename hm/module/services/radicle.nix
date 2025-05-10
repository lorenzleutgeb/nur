{
  config,
  lib,
  pkgs,
  options,
  ...
}: let
  inherit
    (lib)
    generators
    getBin
    getExe
    getExe'
    mapAttrsToList
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    ;

  inherit
    (lib.types)
    attrsOf
    bool
    nullOr
    oneOf
    package
    path
    str
    ;

  cfg = config.services.radicle;
  opt = options.services.radicle;

  radicleHome = config.home.homeDirectory + "/.radicle";

  gitPath = ["PATH=${getBin config.programs.git.package}/bin"];
  env = attrs:
    (mapAttrsToList (generators.mkKeyValueDefault {} "=") attrs)
    ++ gitPath;
in {
  meta.maintainers = with lib.maintainers; [lorenzleutgeb];

  options = {
    services.radicle = {
      node = {
        enable = mkEnableOption "Radicle Node";
        package = mkPackageOption pkgs "radicle-node" {};
        args = mkOption {
          type = str;
          default = "";
          example = "--listen 0.0.0.0:8776";
        };
        environment = mkOption {
          type = attrsOf (nullOr (oneOf [str path package]));
          default = {};
        };
        lazy = mkOption {
          type = bool;
          default = false;
        };
      };
      /*
      httpd = {
        enable = mkEnableOption "Radicle HTTP Daemon";
        package = mkPackageOption pkgs "radicle-httpd" {};
        args = mkOption {
          type = str;
          default = "--listen 127.0.0.1:8080";
        };
        environment = mkOption {
          type = attrsOf (nullOr (oneOf [str path package]));
          default = {};
        };
      };
      */
    };
  };

  config =
    mkIf (
      cfg.node.enable
      /*
      || cfg.httpd.enable
      */
    ) {
      assertions = [
        /*
        {
          assertion = cfg.httpd.enable -> cfg.node.enable;
          message = "`${opt.httpd.enable}` requires `${opt.node.enable}`, since `radicle-httpd` depends on `radicle-node`";
        }
        */
      ];
      systemd.user = {
        services = {
          "radicle-node" =
            mkIf cfg.node.enable
            (let
              keyFile = name: "${radicleHome}/keys/${name}";
              keyPair = name: [(keyFile name) (keyFile (name + ".pub"))];
              radicleKeyPair = keyPair "radicle";
            in {
              Unit = {
                Description = "Radicle Node";
                Documentation = ["https://radicle.xyz/guides" "man:radicle-node(1)"];
                StopWhenUnneeded = cfg.node.lazy;
                ConditionPathExists = radicleKeyPair;
              };
              Service = {
                Slice = "session.slice";
                ExecStart = "${getExe' cfg.node.package "radicle-node"} ${cfg.node.args}";
                Environment = env cfg.node.environment;
                KillMode = "process";
                Restart = "no";
                RestartSec = "2";
                RestartSteps = "100";
                RestartMaxDelaySec = "1min";
              };
            });
          "radicle-node-proxy" = mkIf (cfg.node.enable && cfg.node.lazy) {
            Unit = {
              Description = "Radicle Node Proxy";
              BindsTo = ["radicle-node-proxy.socket" "radicle-node.service"];
              After = ["radicle-node-proxy.socket" "radicle-node.service"];
            };
            Service = {
              Environment = ["SYSTEMD_LOG_LEVEL=debug"];
              ExecSearchPath = "${pkgs.systemd}/lib/systemd";
              ExecStart = "systemd-socket-proxyd --exit-idle-time=5m %t/radicle/proxy.sock";
              PrivateTmp = "yes";
              PrivateNetwork = "yes";
              RuntimeDirectory = "radicle";
              RuntimeDirectoryPreserve = "yes";
            };
          };
          /*
          "radicle-httpd" = mkIf cfg.httpd.enable {
            Unit = {
              Description = "Radicle HTTP Daemon";
              After = ["radicle-node.service"];
              Requires = ["radicle-node.service"];
              Documentation = ["https://radicle.xyz/guides" "man:radicle-httpd(1)"];
            };
            Service = {
              Slice = "session.slice";
              ExecStart = "${getExe' cfg.httpd.package "radicle-httpd"} ${cfg.httpd.args}";
              Environment = env cfg.httpd.environment;
              KillMode = "process";
              Restart = "always";
              RestartSec = "4";
              RestartSteps = "100";
              RestartMaxDelaySec = "2min";
            };
          };
          */
        };
        sockets = mkIf (cfg.node.enable && cfg.node.lazy) {
          "radicle-node-control" = {
            Unit = {
              Description = "Radicle Node Control Socket";
              Documentation = ["man:radicle-node(1)"];
            };
            Socket = {
              Service = "radicle-node-proxy.service";
              ListenStream = "%t/radicle/control.sock";
              RuntimeDirectory = "radicle";
              RuntimeDirectoryPreserve = "yes";
            };
            Install.WantedBy = ["sockets.target"];
          };
          "radicle-node-proxy" = {
            Unit = {
              Description = "Radicle Node Proxy Socket";
              Documentation = ["man:systemd-socket-proxyd(8)"];
            };
            Socket = {
              Service = "radicle-node.service";
              FileDescriptorName = "control";
              ListenStream = "%t/radicle/proxy.sock";
              RuntimeDirectory = "radicle";
              RuntimeDirectoryPreserve = "yes";
            };
            Install.WantedBy = ["sockets.target"];
          };
        };
      };
      programs.radicle.enable = mkDefault true;
      home.sessionVariables = mkIf (cfg.node.enable && cfg.node.lazy) {
        RAD_SOCKET = (config.sessionVariables.XDG_RUNTIME_DIR or "/run/user/$UID") + "/radicle/control.sock";
      };
    };
}
