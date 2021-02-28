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

  programs.feh.enable = true;

  wayland.windowManager.sway = let modifier = "Mod4";
  in {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      inherit modifier;
      fonts = [ "pango:${theme.font.mono} 10" ];
      terminal = "alacritty";
      menu = "rofi -show combi";

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
        "${modifier}+p" = "exec gnome-screenshot --interactive";

        "XF86MonBrightnessUp" = "exec xbacklight -inc 20";
        "XF86MonBrightnessDown" = "exec xbacklight -dec 20";

        "XF86AudioPlay" = "exec playerctl play";
        "XF86AudioPause" = "exec playerctl pause";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPrev" = "exec playerctl previous";

        "XF86AudioRaiseVolume" =
          "exec --no-startup-id pactl set-sink-volume 0 +5%";
        "XF86AudioLowerVolume" =
          "exec --no-startup-id pactl set-sink-volume 0 -5%";
        "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute 0 toggle";
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
      /* focused_workspace  #282828 #282828 #FFFFFF #fdf6e3
         active_workspace   #fdf6e3 #6c71c4 #fdf6e3 #FFFFFF
         inactive_workspace #000000 #000000 #AAAAAA #002b36
         urgent_workspace   #d33682 #d33682 #fdf6e3 #FFFFFF

         # class                 border  bground text    indicator child_border
         client.urgent           #d33682 #d33682 #fdf6e3 #dc322f

         # class                 border  backgr. text    indicator child_border
         client.focused          #4c7899 #285577 #ffffff #2e9ef4   #285577
         client.focused_inactive #333333 #5f676a #ffffff #484e50   #5f676a
         client.unfocused        #333333 #222222 #888888 #292d2e   #222222
         client.urgent           #2f343a #900000 #ffffff #900000   #900000
         client.placeholder      #000000 #0c0c0c #ffffff #000000   #0c0c0c
      */
      startup = [{
        command = "${pkgs.feh}/bin/feh --bg-scale ~/wallpaper.jpg";
        always = true;
        #notification = false;
      }];
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

      #exec "setxkbmap -layout us,de"
      #exec "setxkbmap -option 'grp:alt_shift_toggle'"
      exec systemctl --user import-environment
      exec systemctl --user start graphical-session.target
    '';
    #exec --no-startup-id xsetroot -solid "#000"
  };

  home.packages = with pkgs; [
    swaylock-effects
    swayidle
    wl-clipboard
    wdisplays
    imv
    waypipe
    notify-desktop
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
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
      output = [ "HDMI-A-1" ];
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
    style = ''
      * {
          border: none;
          border-radius: 0;
          /* `otf-font-awesome` is required to be installed for icons */
          font-family: "${theme.font.sans}", sans-serif;
          font-size: 13px;
          min-height: 0;
      }

      window#waybar {
          background-color: rgba(0, 0, 0, 0.3);
          border: none;
          /*border-bottom: 3px solid rgba(100, 114, 125, 0.5); */
          color: #ffffff;
          transition-property: background-color;
          transition-duration: .5s;
      }

      window#waybar.hidden {
          opacity: 0.2;
      }

      /*
      window#waybar.empty {
          background-color: transparent;
      }
      window#waybar.solo {
          background-color: #FFFFFF;
      }
      */

      window#waybar.termite {
          background-color: #3F3F3F;
      }

      window#waybar.chromium {
          background-color: #000000;
          border: none;
      }

      #workspaces button {
          padding: 0 5px;
          background-color: transparent;
          color: #ffffff;
          /* Use box-shadow instead of border so the text isn't offset */
          box-shadow: inset 0 -3px transparent;
      }

      /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
      #workspaces button:hover {
          background: rgba(0, 0, 0, 0.2);
          /*box-shadow: inset 0 -3px #ffffff;*/
      }

      #workspaces button.focused {
          background-color: rgb(50, 50, 50);
          /*box-shadow: inset 0 -3px #ffffff; */
      }

      #workspaces button.urgent {
          background-color: #eb4d4b;
      }

      #mode {
          background-color: #64727D;
          /*border-bottom: 3px solid #ffffff;*/
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #mpd {
          padding: 0 10px;
          margin: 0 4px;
          color: #ffffff;
      }

      #window,
      #workspaces {
          margin: 0 4px;
      }

      /* If workspaces is the leftmost module, omit left margin */
      .modules-left > widget:first-child > #workspaces {
          margin-left: 0;
      }

      /* If workspaces is the rightmost module, omit right margin */
      .modules-right > widget:last-child > #workspaces {
          margin-right: 0;
      }

      #clock {
          background-color: #64727D;
      }

      #battery {
          background-color: #ffffff;
          color: #000000;
      }

      #battery.charging {
          color: #ffffff;
          background-color: #26A65B;
      }

      @keyframes blink {
          to {
              background-color: #ffffff;
              color: #000000;
          }
      }

      #battery.critical:not(.charging) {
          background-color: #f53c3c;
          color: #ffffff;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      label:focus {
          background-color: #000000;
      }

      #cpu {
          background-color: #2ecc71;
          color: #000000;
      }

      #memory {
          background-color: #9b59b6;
      }

      #backlight {
          background-color: #90b1b1;
      }

      #network {
          background-color: #2980b9;
      }

      #network.disconnected {
          background-color: #f53c3c;
      }

      #pulseaudio {
          background-color: #f1c40f;
          color: #000000;
      }

      #pulseaudio.muted {
          background-color: #90b1b1;
          color: #2a5c45;
      }

      #custom-media {
          background-color: #66cc99;
          color: #2a5c45;
          min-width: 100px;
      }

      #custom-media.custom-spotify {
          background-color: #66cc99;
      }

      #custom-media.custom-vlc {
          background-color: #ffa000;
      }

      #temperature {
          background-color: #f0932b;
      }

      #temperature.critical {
          background-color: #eb4d4b;
      }

      #tray {
          background-color: #2980b9;
      }

      #idle_inhibitor {
          background-color: #2d3436;
      }

      #idle_inhibitor.activated {
          background-color: #ecf0f1;
          color: #2d3436;
      }

      #mpd {
          background-color: #66cc99;
          color: #2a5c45;
      }

      #mpd.disconnected {
          background-color: #f53c3c;
      }

      #mpd.stopped {
          background-color: #90b1b1;
      }

      #mpd.paused {
          background-color: #51a37a;
      }

      #language {
          background: #00b093;
          color: #740864;
          padding: 0 5px;
          margin: 0 5px;
          min-width: 16px;
      }
      window#waybar {
          background: rgba(0, 0, 0, 0.4);
          /*border-bottom: 3px solid rgba(100, 114, 125, 0.5);*/
          color: white;
      }
          '';
  };

  home.file."bin/lockscreen".source = ./lockscreen;
}
