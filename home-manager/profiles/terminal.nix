{ lib, pkgs, ... }:

with builtins;

{
  imports = [
    ./common.nix
    ./docker.nix
    ./programs/bat
    ./programs/fzf.nix
    ./programs/gh.nix
    ./programs/git
    ./programs/gpg.nix
    ./programs/nvim
    ./programs/password-store.nix
    ./programs/ripgrep.nix
    ./programs/ssh.nix
    ./programs/tmux
    ./programs/zsh
    ./services/gpg-agent.nix
    ./services/syncthing.nix
    ./services/keybase.nix
  ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  home.packages = with pkgs; [
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    asciinema
    autojump
    beets
    cachix
    chromaprint
    curlFull
    direnv
    dnsutils
    docker-compose
    entr
    exa
    fatrace
    fd
    ffmpeg
    file
    fontconfig
    font-awesome
    fuse
    fzf
    glibcLocales
    graphviz
    htop
    iotop
    kbfs
    mtr
    neovim-remote
    niv
    nixFlakes
    nixfmt
    nixpkgs-review
    nix-index
    noto-fonts
    nvme-cli
    openssl
    pandoc
    pantheon.elementary-files
    pantheon.elementary-photos
    pciutils
    pdfgrep
    pinta
    poppler_utils
    psmisc
    #python38Full
    #python38Packages.pyacoustid
    pwgen
    rclone
    rmapi
    siji
    skaffold
    sshfs-fuse
    universal-ctags
    usbutils
    tailscale
    travis
    tree
    unzip
    vmtouch
    xxHash
    yubikey-personalization
    yubioath-desktop
    zip
  ];
}
