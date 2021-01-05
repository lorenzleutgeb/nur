{ pkgs, ... }:

{
  programs.bat = {
    enable = true;
    config = {
      #theme = "tomorrow-night-bright";
      pager = "less -FR";
    };
    #themes = {
    #  tomorrow-night-bright = builtins.readFile ./tomorrow-night-bright.tmTheme;
    #};
  };
}
