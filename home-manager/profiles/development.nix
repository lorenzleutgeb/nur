{ lib, pkgs, ... }:

with builtins;

{
  imports = [
    ./graphical.nix
    ../programs/bat
    ../programs/browserpass.nix
    ../programs/firefox
    ../programs/fzf.nix
    ../programs/gh.nix
    ../programs/git
    ../programs/go.nix
    #../programs/isabelle.nix
    ../programs/mkcert.nix
    ../programs/nix
    ../programs/nvim
    #../programs/libvirt
    ../programs/password-store.nix
    ../programs/ripgrep.nix
    ../programs/ssh.nix
    ../programs/cakeml.nix
    ../programs/vscode.nix
    ../programs/zsh
    ./jetbrains.nix
    ../services/flameshot.nix
    ../services/mpris-proxy.nix
    ../services/syncthing.nix
    ../services/keybase.nix
  ];

  home.packages = with pkgs; [
    alacritty
    #android-studio
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    asciinema
    autojump
    binutils
    brightnessctl
    cachix
    cmake
    #ctags
    curlFull
    dive
    #dockerTools
    docker-compose
    dos2unix
    droidcam
    elan
    elfutils
    entr
    envsubst
    evince
    exa
    exiftool
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
    gcc
    gdb
    ghcid
    glibcLocales
    gnumake
    google-chrome
    google-cloud-sdk
    gource
    gparted
    graphviz
    hlint
    htop
    insomnia
    iperf
    jdk17
    jq
    kbfs
    kdiff3
    kubectl
    liberation_ttf
    libreoffice
    llvm
    #haskellPackages.miv
    material-icons
    meld
    mupdf
    nmap
    ncdu
    neovim-remote
    niv
    nixfmt
    #nixops
    nixpkgs-review
    nix-index
    nvme-cli
    noto-fonts
    pandoc
    pantheon.elementary-files
    pantheon.elementary-photos
    pavucontrol
    pdfgrep
    #perl532Packages.GitAutofixup
    pinta
    poppler_utils
    pwgen
    python38Full
    python38Packages.beautifulsoup4
    python38Packages.mwclient
    python38Packages.pip
    python38Packages.setuptools
    python38Packages.requests
    python38Packages.yamllint
    ranger
    shellcheck
    shfmt
    siji
    skaffold
    stow
    stylish-haskell
    skypeforlinux
    sshfs-fuse
    teamviewer
    transmission-gtk
    universal-ctags
    monero
    monero-gui
    #nodePackages.node2nix
    #nodePackages.firebase-tools # Custom package
    #nodePackages.turtle-validator # Custom package
    #obsidian
    obs-studio
    #obs-v4l2sink
    #nodejs
    texlive.combined.scheme-full
    roboto
    roboto-mono
    roboto-slab
    skopeo
    swiPrologWithGui
    tio
    tmux
    tree
    vlc
    wally-cli
    wget
    wrangler
    xclip
    xdotool
    yubikey-personalization
    yq
    zoom-us
  ];
}
