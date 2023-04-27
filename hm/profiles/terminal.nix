{ lib, pkgs, ... }:

with builtins;

{
  imports = [
    ./common.nix
    ../programs/docker.nix
    ../programs/bat
    ../programs/direnv
    ../programs/fzf.nix
    ../programs/gh.nix
    ../programs/git
    ../programs/gpg.nix
    ../programs/nvim
    ../programs/password-store.nix
    ../programs/ripgrep.nix
    ../programs/ssh.nix
    ../programs/tmux
    ../programs/zsh
    ../services/gpg-agent.nix
    ../services/syncthing.nix
    ../services/keybase.nix
  ];

  home.packages = with pkgs; [
    asciinema
    autojump
    beets
    cachix
    chromaprint
    curlFull
    dasel
    dnsutils
    docker-compose
    entr
    exa
    fatrace
    fd
    ffmpeg
    file
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
    nixfmt
    nixpkgs-review
    nvme-cli
    openssl
    pandoc
    pantheon.elementary-files
    pantheon.elementary-photos
    parted
    pciutils
    pdfgrep
    pdftk
    phoronix-test-suite
    pinta
    poppler_utils
    psmisc
    pv
    #python38Full
    #python38Packages.pyacoustid
    pwgen
    rclone
    rmapi
    siji
    signal-cli
    skaffold
    sshfs-fuse
    universal-ctags
    usbutils
    tree
    unzip
    vmtouch
    xxHash
    yubikey-personalization
    zip
    zola
  ];

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };
}