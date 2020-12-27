{ lib, pkgs, ... }:

with builtins;

{
  imports = [
    ./wm/i3
    ./programs/autorandr.nix
    ./programs/bat
    ./programs/browserpass.nix
    ./programs/firefox
    ./programs/fzf.nix
    ./programs/gh.nix
    ./programs/git
    ./programs/nvim
    ./programs/password-store.nix
    ./programs/ripgrep.nix
    ./programs/ssh.nix
    ./programs/zsh
    ./services/flameshot.nix
    ./services/mpris-proxy.nix
    ./services/syncthing.nix
    ./services/keybase.nix
  ];

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      enableNixDirenvIntegration = true;
    };
    gpg = {
      enable = true;
      settings = { keyserver = "hkps://lorenz.leutgeb.xyz:443/"; };
    };
  };

  xdg = {
    enable = true;
    mimeApps.enable = true;
  };

  manual.html.enable = true;

  #nixpkgs.config.allowUnfree = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.03";

  home.packages = with pkgs; [
    alacritty
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    asciinema
    autojump
    brightnessctl
    cachix
    #ctags
    curlFull
    direnv
    #dockerTools
    docker-compose
    entr
    evince
    exa
    exercism
    fd
    file
    fira
    fira-code
    fira-code-symbols
    fira-mono
    fontconfig
    font-awesome
    #fwupdmgr
    fzf
    ghcid
    glibcLocales
    googleearth
    google-chrome
    google-cloud-sdk
    gource
    gparted
    graphviz
    hlint
    htop
    insomnia
    isabelle
    jdk11
    jetbrains.idea-ultimate
    jetbrains.goland
    jq
    kbfs
    kdiff3
    kubectl
    #haskellPackages.miv
    material-icons
    meld
    ncat
    ncdu
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
    python38Full
    python38Packages.beautifulsoup4
    python38Packages.mwclient
    python38Packages.pip
    python38Packages.setuptools
    python38Packages.requests
    python38Packages.yamllint
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
    monero
    monero-gui
    nodePackages.node2nix
    nodePackages.firebase-tools # Custom package
    nodePackages.turtle-validator # Custom package
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

  services = { flameshot.enable = true; };

  fonts.fontconfig.enable = pkgs.lib.mkForce true;
}
