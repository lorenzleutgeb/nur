{ pkgs, lib, ... }:

with builtins;

let
  theme = {
    font = {
      sans = "Fira Sans";
      mono = "Fira Mono";
    };
    color = {
      normal = {
        black = "#1d1f21";
        red = "#cc6666";
        green = "#b5bd68";
        yellow = "#f0c674";
        blue = "#81a2be";
        magenta = "#b294bb";
        cyan = "#8abeb7";
        white = "#c5c8c6";
      };
      bright = {
        black = "#666666";
        red = "#d54e53";
        green = "#b9ca4a";
        yellow = "#e7c547";
        blue = "#7aa6da";
        magenta = "#c397d8";
        cyan = "#70c0b1";
        white = "#eaeaea";
      };
      dim = {
        black = "#131415";
        red = "#864343";
        green = "#777c44";
        yellow = "#9e824c";
        blue = "#556a7d";
        magenta = "#75617b";
        cyan = "#5b7d78";
        white = "#828482";
      };
      highlight = {
        white = "#ffffff";
        black = "#000000";
      };
    };
  };
in {
  gtk.enable = true;

  services.mpd = { enable = true; };

  services.gammastep = {
    enable = true;
    latitude = "48.210033";
    longitude = "16.363449";
  };

  wayland.windowManager.sway = let modifier = "Mod4";
  in {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      inherit modifier;
      fonts = {
        names = [ "${theme.font.mono}" ];
        size = 10.0;
      };
      terminal = "alacritty";
      menu = "ulauncher";

      keybindings = pkgs.lib.mkOptionDefault {
        "${modifier}+Shift+0" = "move container to workspace 10";
        "${modifier}+0" = "workspace 10";

        "${modifier}+o" = "exec lockscreen";
        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";
        "${modifier}+z" = "split h";
        "${modifier}+p" = "exec screenshot";

        #"XF86MonBrightnessUp" = "exec xbacklight -inc 20";
        #"XF86MonBrightnessDown" = "exec xbacklight -dec 20";

        "XF86AudioPlay" = "exec playerctl play-pause";
        #"XF86AudioPause" = "exec playerctl pause";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPrev" = "exec playerctl previous";

        "XF86AudioRaiseVolume" = "exec amixer set Master 10%+";
        "XF86AudioLowerVolume" = "exec amixer set Master 10%-";
        "XF86AudioMute" = "exec amixer set Master toggle";
      };

      modes = {
        resize = {
          "Left" = "resize shrink width  10 px or 10 ppt";
          "Down" = "resize grow   height 10 px or 10 ppt";
          "Up" = "resize shrink height 10 px or 10 ppt";
          "Right" = "resize grow   width  10 px or 10 ppt";

          "h" = "resize shrink width  10 px or 10 ppt";
          "j" = "resize grow   height 10 px or 10 ppt";
          "k" = "resize shrink height 10 px or 10 ppt";
          "l" = "resize grow   width  10 px or 10 ppt";

          "Escape" = "mode default";
          "Return" = "mode default";
        };
      };

      output = { "*" = { "background" = "~/Pictures/nix-color.png fill"; }; };

      # Idea for workspaces:
      #   1 ?
      #   2 Messaging    Thunderbird, Skype, Signal
      #   3 ?
      #   4 Browsers     Firefox
      #   5 avoided since key is not directly above home row
      #   6 avoided since key is not directly above home row
      #   7 Terminals    Alacritty
      #   8 IDE          IntelliJ, VSCode
      #   9 Music        Spotify
      #  10 ?
      assigns = {
        "2" = [
          { app_id = "Signal"; }
          { app_id = "Skype"; }
          { app_id = "Slack"; }
          { app_id = "^.*Thunderbird.*$"; }
        ];
        "4" = [{ app_id = "^[F|f]irefox$"; }];
        "7" = [{ app_id = "^[A|a]lacritty$"; }];
        "8" = [ { app_id = "Code"; } { app_id = "^.*jetbrains-.*$"; } ];
        "9" = [{ app_id = "^[S|s]potify.*"; }];
      };

      floating.criteria = [
        { "app_id" = "Ibus-ui-gtk3"; }
        { "app_id" = "Nm-connection-editor"; }
        { "app_id" = "Pinentry"; }
      ];

      colors = {
        focused = {
          background = "#222222";
          border = "#333333";
          childBorder = "#285577";
          indicator = "#2e9ef4";
          text = "#ffffff";
        };
        focusedInactive = {
          background = "#5f676a";
          border = "#333333";
          childBorder = "#5f676a";
          indicator = "#484e50";
          text = "#ffffff";
        };
        unfocused = {
          background = "#000000";
          border = "#333333";
          childBorder = "#222222";
          indicator = "#292d2e";
          text = "#888888";
        };
        urgent = {
          background = "#900000";
          border = "#2f343a";
          childBorder = "#900000";
          indicator = "#900000";
          text = "#ffffff";
        };
        placeholder = {
          background = "#0c0c0c";
          border = "#000000";
          childBorder = "#0c0c0c";
          indicator = "#000000";
          text = "#ffffff";
        };
      };

      bars = [ ];

      input."1149:32792:Kensington_Expert_Wireless_TB_Mouse".pointer_accel =
        "0.7";
    };
    extraConfig = ''
      hide_edge_borders both
      default_border none
      for_window [app_id="Signal" workspace=2] border none
      for_window [app_id="Firefox" workspace=4] border none
      for_window [app_id="^.*jetbrains-.*$" workspace=8] border none
      for_window [app_id="Alacritty"] border none
      #for_window [title=".* Sharing Indicator"] floating enable

      for_window [title="Firefox — Sharing Indicator"] kill;

      # IntelliJ Splash Screen
      for_window [class="^.*jetbrains-.*$" title="win0"] floating enable;
      # IntelliJ Welcome Screen
      for_window [class="^.*jetbrains-.*$" title="Welcome to .*"] floating enable;

      exec systemctl --user import-environment
      exec systemctl --user start graphical-session.target
    '';
  };

  gtk = {
    iconTheme = {
      name = "Elementary";
      package = pkgs.pantheon.elementary-icon-theme;
    };
  };

  home.packages = with pkgs; [
    grim # Screenshots
    imv # Image viewer
    notify-desktop # Notification testing
    playerctl # Media keys
    slurp # Selecting region (for screenshots)
    swayidle # Lock when inactive
    swaylock-effects # Lockscreen
    wdisplays # List available displays
    wl-clipboard # Access clipboard
    waypipe # Network transparency
    ulauncher # Applications launcher
    wayvnc # VNC Server

    # Gnome
    gsettings-desktop-schemas
    pantheon.elementary-icon-theme
    gnome3.adwaita-icon-theme
    gnome.gnome-tweaks

    (pkgs.writeTextFile {
      name = "startsway";
      destination = "/bin/startsway";
      executable = true;
      text = let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in ''
        #! ${pkgs.bash}/bin/bash
        ${pkgs.openssh}/bin/ssh-add
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        # first import environment variables from the login manager
        systemctl --user import-environment
        # then start the service
        exec systemctl --user start sway.service
      '';
    })

    (pkgs.writeScriptBin "lockscreen" (builtins.readFile ./lockscreen.sh))
    (pkgs.writeScriptBin "screenshot" (builtins.readFile ./screenshot.sh))
  ];

  xdg.systemDirs.data = with pkgs; let
    schema = gsettings-desktop-schemas;
  in [ 
    "${gtk3}/share/gsettings-schemas/${gtk3.name}"
    "${schema}/share/gsettings-schemas/${schema.name}"
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  programs.mako = {
    enable = true;
    anchor = "bottom-center";
    backgroundColor = "#00000033";
    borderColor = "#333333FF";
    borderRadius = 3;
    borderSize = 2;
    defaultTimeout = 10 * 1000;
    font = "${theme.font.sans} 12";
    width = 2560 / 4;
    height = 1440 / 10;
    extraConfig = ''
      [app-name="Spotify"]
      border-color=#1DB954
      [app-name="Spotify Premium"]
      border-color=#1DB954
      [app-name="Firefox"]
      border-color=#E66000
      [urgency=high actionable]
      border-color=#ff0000
    '';
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [{
      layer = "top";
      position = "top";
      height = 10;
      output = [ "DP-1" ];
      modules-left = [ "sway/workspaces" "sway/mode" ];
      modules-center = [ "sway/window" ];
      modules-right = [ "cpu" "memory" "network" "temperature" "clock" "tray" ];
      modules = {
        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
          format-icons = {

            "7" = "";
            "4" = "";
            "0" = "";
            "8" = "";
            "9" = "";
            "2" = "";
            "urgent" = "";
            "focused" = "";
            "default" = "";
          };
        };
        "memory" = {
          format = "mem {}%";
          interval = 5;
        };
        "cpu" = {
          format = "cpu {}%";
          interval = 1;
        };
        "clock" = {
          format = "{:%Y-%m-%d %H:%M:%S}";
          interval = 1;
        };
      };
    }];
    style = readFile ./waybar.css;
  };

  xdg.configFile."wayvnc/config".text = ''
    address=100.85.40.10
    enable_auth=false
  '';
}
