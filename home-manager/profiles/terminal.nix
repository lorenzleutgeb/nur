{ lib, pkgs, ... }:

with builtins;

{
  imports = [
    ./common.nix
    ./docker.nix
    ./programs/bat
    ./programs/direnv
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
    dasel
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
    nixfmt
    nixpkgs-review
    noto-fonts
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
    travis
    tree
    unzip
    vmtouch
    xxHash
    yubikey-personalization
    yubioath-desktop
    zip
  ];

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };
}
