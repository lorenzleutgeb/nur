{
  lib,
  pkgs,
  super,
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
    if super.enable4k
    then {GDK_DPI_SCALE = "1.5";}
    else {};

  home.packages = with pkgs; [
    baobab
    #breitbandmessung
    brightnessctl
    evince
    fira
    fira-code
    fira-code-symbols
    fira-mono
    fontconfig
    font-awesome
    #fwupdmgr
    glibcLocales
    gimp
    networkmanagerapplet
    #googleearth
    google-chrome
    google-cloud-sdk
    gource
    gparted
    graphviz
    insomnia
    neovim-remote
    niv
    noto-fonts
    pantheon.elementary-files
    pantheon.elementary-photos
    pavucontrol
    pinta
    picard
    portfolio
    psensor
    qnotero
    ranger
    rclone-browser
    shfmt
    siji
    skaffold
    stow
    stylish-haskell
    skypeforlinux
    sshfs-fuse
    # talon-bin # Custom package
    teams
    teamviewer
    transmission-gtk
    universal-ctags
    obs-studio
    #obs-v4l2sink
    #nodejs
    #texlive.combined.scheme-full
    tmux
    #tor-browser-bundle-bin
    vlc
    wrangler
    xclip
    xdotool
    yubikey-personalization
    yubikey-personalization-gui
    yq
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
