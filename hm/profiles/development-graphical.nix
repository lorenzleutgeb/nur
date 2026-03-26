{
  lib,
  pkgs,
  ...
}:
with builtins; {
  imports = [
    ./graphical.nix
  ];

  home.packages = with pkgs; [
    baobab
    gimp
    networkmanagerapplet
    gource
    gparted
    insomnia
    meld
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
    sshfs-fuse
    teamviewer
    transmission_4-gtk
    universal-ctags
    obs-studio
    xclip
    xdotool
    yq

    m17n_db
    m17n_lib
  ];
}
