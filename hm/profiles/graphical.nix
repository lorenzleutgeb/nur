{
  lib,
  pkgs,
  ...
}:
with builtins; {
  imports = [
    ../programs/alacritty
    ../programs/firefox
    ../programs/signal-desktop
    ../programs/thunderbird.nix
    ../programs/zathura.nix
    ../services/ulauncher.nix
    ./input-method.nix
    ./sway
    ./terminal.nix
  ];

  home.sessionVariables.GDK_DPI_SCALE = "1.5";

  home.packages = with pkgs; [
    baobab
    brightnessctl
    evince
    fira
    fira-code
    fira-code-symbols
    fira-mono
    fontconfig
    font-awesome
    glibcLocales
    gimp
    gparted
    graphviz
    insomnia
    libreoffice
    noto-fonts
    pantheon.elementary-files
    pantheon.elementary-photos
    pavucontrol
    pinta
    picard
    portfolio
    rclone-browser
    siji
    transmission_4-gtk
    obs-studio
    vlc
    m17n_db
    m17n_lib
  ];
}
