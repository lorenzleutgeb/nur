{ lib, pkgs, ... }:

with builtins;

{
  imports = [
    ./terminal.nix
    ./wm/i3
    ./programs/autorandr.nix
    ./programs/browserpass.nix
    ./programs/firefox
    ./programs/password-store.nix
  ];

  home.packages = with pkgs; [
    alacritty
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
    googleearth
    google-chrome
    google-cloud-sdk
    gource
    gparted
    graphviz
    insomnia
    neovim-remote
    niv
    nixFlakes
    nixfmt
    nixops
    nixpkgs-review
    nix-index
    noto-fonts
    obsidian
    pandoc
    pantheon.elementary-files
    pantheon.elementary-photos
    pavucontrol
    pdfgrep
    pinta
    poppler_utils
    ranger
    rofi
    shellcheck
    shfmt
    signal-desktop
    siji
    skaffold
    spotify
    stow
    stylish-haskell
    skypeforlinux
    sshfs-fuse
    talon-bin # Custom package
    thunderbird
    teamviewer
    transmission-gtk
    universal-ctags
    obs-studio
    obs-v4l2sink
    #nodejs
    #texlive.combined.scheme-full
    tailscale
    tmux
    tor-browser-bundle-bin
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
    zathura
    zoom-us
  ];
}
