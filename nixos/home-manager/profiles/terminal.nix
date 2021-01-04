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
    ./programs/tmux.nix
    ./programs/zsh
    ./services/gpg-agent.nix
    ./services/syncthing.nix
    ./services/keybase.nix
  ];

  programs = {
    direnv = {
      enable = true;
      enableNixDirenvIntegration = true;
    };
  };

  home.packages = with pkgs; [
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    asciinema
    autojump
    cachix
    #ctags
    curlFull
    direnv
    #dockerTools
    dnsutils
    docker-compose
    entr
    exa
    fd
    file
    fontconfig
    font-awesome
    #fwupdmgr
    fzf
    glibcLocales
    graphviz
    htop
    kbfs
    mtr
    neovim-remote
    niv
    nixFlakes
    nixfmt
    nixops
    nixpkgs-review
    nix-index
    noto-fonts
    pandoc
    pantheon.elementary-files
    pantheon.elementary-photos
    pdfgrep
    pinta
    poppler_utils
    python38Full
    rclone
    rmapi
    siji
    skaffold
    sshfs-fuse
    universal-ctags
    #nodejs
    #texlive.combined.scheme-full
    tailscale
    travis
    tree
    xdotool
    yubikey-personalization
    yubioath-desktop
  ];
}
