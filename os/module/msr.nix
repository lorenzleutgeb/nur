{ lib
, config
, options
, ...
}:
let
  inherit (builtins) hasAttr;
  inherit (lib) mkIf mdDoc;
  cfg = config.hardware.cpu.intel.msr;
  opt = options.hardware.cpu.intel.msr;
  defaultGroup = "msr";
  isDefaultGroup = cfg.group == defaultGroup;
  set = "to set for devices of the `msr` kernel subsystem.";
in
{
  options.hardware.cpu.intel.msr = with lib.options; {
    enable = mkEnableOption (mdDoc "the `msr` (Model-Specific Registers) kernel module and configure `udev` rules for its devices (usually `/dev/cpu/*/msr`)");
    owner = mkOption {
      type = lib.types.str;
      default = "root";
      example = "nobody";
      description = mdDoc "Owner ${set}";
    };
    group = mkOption {
      type = lib.types.str;
      default = defaultGroup;
      example = "nobody";
      description = mdDoc "Group ${set}";
    };
    mode = mkOption {
      type = lib.types.str;
      default = "0640";
      example = "0660";
      description = mdDoc "Mode ${set}";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = hasAttr cfg.owner config.users.users;
        message = "Owner '${cfg.owner}' set in `${opt.owner}` is not configured via `${options.users.users}.\"${cfg.owner}\"`.";
      }
      {
        assertion = isDefaultGroup || (hasAttr cfg.group config.users.groups);
        message = "Group '${cfg.group}' set in `${opt.group}` is not configured via `${options.users.groups}.\"${cfg.group}\"`.";
      }
    ];

    boot.kernelModules = [ "msr" ];

    users.groups.${cfg.group} = mkIf isDefaultGroup { };

    services.udev.extraRules = ''
      SUBSYSTEM=="msr", OWNER="${cfg.owner}", GROUP="${cfg.group}", MODE="${cfg.mode}"
    '';
  };
}
