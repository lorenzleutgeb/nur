{ lib, pkgs, super, ... }:

with builtins;

{
  imports = [
    ./terminal.nix
    ./wm/sway
    ./programs/alacritty
    ./programs/browserpass.nix
    ./programs/firefox
    ./programs/password-store.nix
    ./programs/spotify
    ./programs/signal-desktop
    ./programs/thunderbird
    ./programs/zathura.nix
    ./services/ulauncher.nix
  ];

  home.sessionVariables =
    if super.enable4k then { GDK_DPI_SCALE = "1.5"; } else { };

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
    #fwupdmgr
    glibcLocales
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
    nixpkgs-review
    noto-fonts
    obsidian
    pandoc
    pantheon.elementary-files
    pantheon.elementary-photos
    pavucontrol
    pdfgrep
    pinta
    picard
    poppler_utils
    portfolio
    qnotero
    ranger
    rclone-browser
    shellcheck
    shfmt
    siji
    skaffold
    stow
    stylish-haskell
    skypeforlinux
    sshfs-fuse
    # talon-bin # Custom package
    teamviewer
    transmission-gtk
    universal-ctags
    obs-studio
    #obs-v4l2sink
    #nodejs
    #texlive.combined.scheme-full
    tailscale
    tmux
    #tor-browser-bundle-bin
    travis
    tree
    vlc
    wally-cli
    wrangler
    xclip
    xdotool
    yubikey-personalization
    yubikey-personalization-gui
    yubioath-desktop
    yq
    zoom-us
    zotero
  ];
}
