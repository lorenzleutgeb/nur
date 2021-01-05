{...}:

{
  programs.alacritty.enable = true;

  # Too lazy to use programs.alacritty.settings
  xdg.configFile."alacritty/alacritty.yaml".source = ./alacritty.yaml;
}
