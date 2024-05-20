{
  config,
  options,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.concourse-web;
  opt = options.services.concourse-web;
  x = "concourse";
in {
  meta.maintainers = with lib.maintainers; [lorenzleutgeb];
  options.services.concourse-web = {
    # Refer to https://concourse-ci.org/concourse-generate-key.html
    enable = lib.mkEnableOption "Concourse CI Web Node";
    package = lib.mkPackageOption pkgs x {};
    settings = lib.mkOption {
      type = with lib.types; attrsOf (oneOf [str number path]);
      description = "Concourse CI settings mapped to environment variables.";
      default = {
        CONCOURSE_RUNTIME = "containerd";
      };
    };
    database = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Create the database and database user locally.";
      };
    };
  };
  config = {
    systemd.services.concourse-web = lib.mkIf cfg.enable {
      documentation = [
        "https://concourse-ci.org/concourse-web.html"
      ];
      after = lib.optional cfg.database.createLocally "postgresql.service";
      wantedBy = ["multi-user.target"];
      serviceConfig = let
        postgres =
          if cfg.database.createLocally
          then {
            CONCOURSE_POSTGRES_DATABASE = x;
            CONCOURSE_POSTGRES_USER = x;
            #CONCOURSE_POSTGRES_PASSWORD = x;
            CONCOURSE_POSTGRES_SOCKET = "/var/run/postgresql";
          }
          else {};
        settings = postgres // cfg.settings;
      in {
        User = x;
        EnvironmentFile = pkgs.writeText "concourse-web.env" (lib.generators.toKeyValue {} (lib.debug.traceVal settings));
        ExecStart = "${lib.getExe cfg.package} web";
      };
    };

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
      ensureUsers = [
        {
          name = x;
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = [x];
    };

    users = {
      users.${x} = {
        isSystemUser = true;
        group = x;
      };
      groups.${x} = {};
    };
  };
}
