{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.ulauncher;
in {
  options = {
    services.ulauncher = {
      enable = mkEnableOption "Ulauncher application launcher for Linux";

      package = mkOption {
        type = types.package;
        default = pkgs.ulauncher;
        defaultText = "pkgs.ulauncher";
        description = "Ulauncher derivation to use";
      };

      config = {
        # TODO: Default shortcuts, according to https://github.com/Ulauncher/Ulauncher/blob/4833e779332ac1a439e3fce1f96af684214683b8/ulauncher/config.py#L105-L135
        shortcuts = mkOption {
          type = types.anything;
          default = {};
        };

        settings = mkOption {
          type = with types;
            attrsOf (either (either (either str int) bool) float);
          default = {};
        };

        extensions = mkOption {
          type = types.attrsOf types.package;
          default = {};

          # TODO: Extension preferences are stored
          # https://github.com/Ulauncher/Ulauncher/blob/4833e779332ac1a439e3fce1f96af684214683b8/ulauncher/api/server/ExtensionPreferences.py
          # https://github.com/Ulauncher/Ulauncher/blob/4833e779332ac1a439e3fce1f96af684214683b8/ulauncher/utils/db/KeyValueDb.py
          # https://github.com/Ulauncher/Ulauncher/blob/4833e779332ac1a439e3fce1f96af684214683b8/ulauncher/utils/db/KeyValueJsonDb.py
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    systemd.user.services.ulauncher = {
      # https://github.com/Ulauncher/Ulauncher/blob/dev/contrib/systemd/ulauncher.service
      # TODO: Include in derivation and reference here?
      Unit = {
        Description = "Linux Application Launcher";
        Documentation = "https://ulauncher.io/";
        After = "display-manager.service";
      };

      Service = {
        Type = "simple";
        Restart = "always";
        RestartSec = "1";
        ExecStart = "${cfg.package}/bin/ulauncher --hide-window";
      };

      Install = {WantedBy = ["graphical.target"];};
    };

    xdg.dataFile = mapAttrs' (name: value:
      nameValuePair "ulauncher2/extensions/${name}" {source = value.out;})
    cfg.config.extensions;

    xdg.configFile = {
      "ulauncher/settings.json".text = builtins.toJSON cfg.config.settings;
      #"ulauncher/shortcuts.json".text = builtins.toJSON cfg.config.shortcuts;
      "ulauncher/extensions.json".text = builtins.toJSON (mapAttrs
        (name: value: {
          id = name;
          last_commit = value.rev;
          last_commit_time = "1970-01-01T00:00:00Z";
          updated_at = "1970-01-01T00:00:00Z";
          url = value.meta.homepage;
        })
        cfg.config.extensions);
    };
  };
}
