{...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        background_opacity = 1;

        dimensions = {
          columns = 80;
          lines = 24;
        };

        # Window padding (changes require restart)
        #
        # Blank space added around the window in pixels. This padding is scaled
        # by DPI and the specified value is always added at both opposing sides.
        padding = {
          x = 2;
          y = 2;
        };

        # Spread additional padding evenly around the terminal content.
        dynamic_padding = false;

        # Window decorations
        #
        # Values for `decorations`:
        #     - full: Borders and title bar
        #     - none: Neither borders nor title bar
        decorations = "full";

        startup_mode = "Windowed";

        dynamic_title = true;
      };

      scrolling = {
        history = 10000;

        multiplier = 3;
      };

      font = {
        normal.family = "Fira Code";
        bold = {
          family = "Fira Code";
          style = "Bold";
        };
        italic = {
          family = "Fira Code";
          style = "Italic";
        };

        size = 16;
        offset = {
          x = 0;
          y = 0;
        };

        glyph_offset = {
          x = 0;
          y = 0;
        };
      };

      draw_bold_text_with_bright_colors = true;

      colors = {
        background = "0x000000";
      };

      bell = {
        animation = "EaseOutExpo";
        duration = 0;
        color = "0xffffff";
      };

      mouse_bindings = [
        {
          mouse = "Middle";
          action = "PasteSelection";
        }
      ];

      mouse = {
        double_click.threshold = 300;
        triple_click.threshold = 300;

        hide_when_typing = false;

        selection = {
          semantic_escape_chars = ",│`|:\"' ()[]{}<>";
          save_to_clipboard = false;
        };

        cursor = {
          style = "Block";
          unfocused_hollow = true;
        };

        shell.program = "zsh";
      };
    };
  };
}
