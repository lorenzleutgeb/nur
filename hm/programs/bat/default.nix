{pkgs, ...}: {
  programs.bat = {
    enable = true;
    config.pager = "less -FR";
  };

  home.sessionVariables.BAT_STYLE = "numbers,changes";
}
