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
    submodule
    ;

  cfg = config.services.radicle-mirror;
  opt = options.services.radicle-mirror;

  radicleHome = config.home.homeDirectory + "/.radicle";
in {
  meta.maintainers = with lib.maintainers; [lorenzleutgeb];

  options = {
    services.radicle-mirror = mkOption {
      type = attrsOf (submodule {
        options = {
          rid = mkOption {
            description = "Radicle Repository ID";
            type = str;
          };
          remote = mkOption {
            description = "Git repository to mirror to.";
            type = str;
          };
        };
      });
    };
  };

  config = {
    systemd.user = {
      paths =
        lib.mapAttrs' (rid: {remote, ...}: {
          name = "radicle-mirror-${rid}";
          value = {
            Unit = {
              Description = "Mirror ${rid} to ${remote}";
            };
            Path = {
              PathChanged = "${config.home.homeDirectory}/.radicle/storage/${rid}/refs/{heads,tags}";
            };
          };
        })
        cfg;

      services =
        lib.mapAttrs' (rid: {remote, ...}: {
          name = "radicle-mirror-${rid}";
          value = {
            Unit = {
              Description = "Mirror ${rid} to ${remote}";
            };
            Service = {
              Type = "oneshot";
              ExecStart = "${lib.getExe pkgs.git} push --mirror ${remote}";
              WorkingDirectory = "${config.home.homeDirectory}/.radicle/storage/${rid}";
              Environment = ["PATH=${getBin pkgs.openssh}/bin"];
            };
          };
        })
        cfg;
    };
  };
}
