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
    ../programs/browserpass.nix
    ../programs/firefox
    ../programs/password-store.nix
    ../programs/spotify
    ../programs/signal-desktop
    ../programs/thunderbird.nix
    ../programs/zathura.nix
    ../services/ulauncher.nix
    ../services/gnome-keyring.nix
  ];

  home.sessionVariables =
    if
      /*
      super.enable4k
      */
      true
    then {GDK_DPI_SCALE = "1.5";}
    else {};

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
    neovim-remote
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
    yubikey-personalization
    yubikey-personalization-gui
    zoom-us
    zotero

    m17n_db
    m17n_lib
  ];

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [fcitx5-m17n];
  };
}
