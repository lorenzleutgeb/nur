{
  lib,
  pkgs,
  ...
}:
with builtins; {
  imports = [
    ./graphical.nix
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
    gimp
    networkmanagerapplet
    gource
    gparted
    insomnia
    meld
    neovim-remote
    niv
    pinta
    picard
    portfolio
    qnotero
    rclone-browser
    shfmt
    siji
    stow
    stylish-haskell
    skypeforlinux
    sshfs-fuse
    teamviewer
    transmission_4-gtk
    universal-ctags
    obs-studio
    wrangler
    xclip
    xdotool
    yubikey-personalization
    yubikey-personalization-gui
    yq

    m17n_db
    m17n_lib
  ];

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [fcitx5-m17n];
  };
}
