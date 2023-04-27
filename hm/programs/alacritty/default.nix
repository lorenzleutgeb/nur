{ ... }:

{
  programs.alacritty.enable = true;

  # Too lazy to use programs.alacritty.settings
  xdg.configFile."alacritty/alacritty.yml".source = ./alacritty.yaml;
}
