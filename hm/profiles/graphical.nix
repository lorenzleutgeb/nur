{
  lib,
  pkgs,
  ...
}:
with builtins; {
  imports = [
    ./input-method.nix
    ./terminal.nix
    ./sway
    ../programs/alacritty
    ../programs/firefox
    ../programs/spotify
    ../programs/signal-desktop
    ../programs/thunderbird.nix
    ../programs/zathura.nix
    #../services/mpris-proxy.nix
    ../services/ulauncher.nix
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
    networkmanagerapplet
    google-chrome
    gource
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
    qnotero
    rclone-browser
    shfmt
    siji
    teamviewer
    transmission_4-gtk
    obs-studio
    vlc
    xclip
    xdotool
    zoom-us
    zotero

    m17n_db
    m17n_lib
  ];
}
