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

  services.picom = {
    enable = true;
    experimentalBackends = true;
    backend = "xrender";
    extraOptions = "";
  };

  programs.feh.enable = true;

  xsession.enable = true;
  xsession.windowManager.i3 = let modifier = "Mod4";
  in {
    enable = true;
    config = {
      inherit modifier;
      fonts = [ "pango:${theme.font.mono} 10" ];
      terminal = "alacritty";
      menu = "rofi -show combi";

      keybindings = pkgs.lib.mkOptionDefault {
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
      assigns = {
        "2" = [
          { class = "Signal"; }
          { class = "Skyp"; }
          { class = "Slack"; }
          { class = "Thunderbird"; }
        ];
        "4" = [{ class = "Firefox"; }];
        "7" = [{ class = "Alacritty"; }];
        "8" = [ { class = "Code"; } { class = "^.*jetbrains-.*$"; } ];
        "9" = [{ class = "Spotify"; }];
      };

      floating.criteria = [
        { "class" = "Ibus-ui-gtk3"; }
        { "class" = "Nm-connection-editor"; }
        { "class" = "Pinentry"; }
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
        notification = false;
      }];
    };
    extraConfig = ''
      hide_edge_borders smart
      for_window [class="Signal" workspace=2] border pixel 0
      for_window [class="Firefox" workspace=4] border pixel 0
      for_window [class="^.*jetbrains-.*$" workspace=8] border pixel 0
      for_window [workspace=7] border pixel 0

      exec "setxkbmap -layout us,de"
      exec "setxkbmap -option 'grp:alt_shift_toggle'"
    '';
    #exec --no-startup-id xsetroot -solid "#000"
  };

  services.polybar = {
    enable = true;
    config = ./polybar;
    script = "polybar top &";
    extraConfig = ''
      [theme]
      normal-black = ${theme.color.normal.black}
      normal-red = ${theme.color.normal.red}
      normal-green = ${theme.color.normal.green}
      normal-yellow = ${theme.color.normal.yellow}
      normal-blue = ${theme.color.normal.blue}
      normal-magenta = ${theme.color.normal.magenta}
      normal-cyan = ${theme.color.normal.cyan}
      normal-white = ${theme.color.normal.white}
      bright-black = ${theme.color.bright.black}
      bright-red = ${theme.color.bright.red}
      bright-green = ${theme.color.bright.green}
      bright-yellow = ${theme.color.bright.yellow}
      bright-blue = ${theme.color.bright.blue}
      bright-magenta = ${theme.color.bright.magenta}
      bright-cyan = ${theme.color.bright.cyan}
      bright-white = ${theme.color.bright.white}
      dim-black = ${theme.color.dim.black}
      dim-red = ${theme.color.dim.red}
      dim-green = ${theme.color.dim.green}
      dim-yellow = ${theme.color.dim.yellow}
      dim-blue = ${theme.color.dim.blue}
      dim-magenta = ${theme.color.dim.magenta}
      dim-cyan = ${theme.color.dim.cyan}
      dim-white = ${theme.color.dim.white}
      highlight-black = ${theme.color.highlight.black}
      highlight-white = ${theme.color.highlight.white}
    '';
  };

  programs.rofi = {
    enable = true;
    font = "${theme.font.sans} 16";
    separator = "solid";
    colors = {
      window = {
        background = theme.color.normal.black;
        border = theme.color.highlight.black;
        separator = theme.color.dim.black;
      };

      rows = {
        normal = {
          foreground = theme.color.normal.white;
          background = theme.color.normal.black;
          backgroundAlt = theme.color.dim.black;
          highlight = {
            foreground = theme.color.highlight.white;
            background = theme.color.highlight.black;
          };
        };
        active = {
          foreground = theme.color.bright.white;
          background = theme.color.bright.black;
          backgroundAlt = theme.color.highlight.black;
          highlight = {
            foreground = theme.color.highlight.white;
            background = theme.color.highlight.black;
          };
        };
        urgent = {
          foreground = theme.color.normal.red;
          background = theme.color.normal.black;
          backgroundAlt = theme.color.dim.black;
          highlight = {
            foreground = theme.color.bright.red;
            background = theme.color.dim.red;
          };
        };
      };
    };
    extraConfig = let setOption = name: value: "rofi.${name}: ${value}";
    in ''
      ${setOption "modi" "combi"}
      ${setOption "combi-modi" "window,drun,run"}
      ${setOption "show-icons" "true"}
    '';
  };

  #xdg.configFile."rofi/config".text = readFile ./rofi;

  home.packages = with pkgs; [ xbindkeys xbindkeys-config rofi-pass rofi-calc ];
}
