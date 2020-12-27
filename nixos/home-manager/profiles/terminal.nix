{ lib, pkgs, ... }:

with builtins;

{
  imports = [
    ./common.nix
    ./programs/bat
    ./programs/fzf.nix
    ./programs/gh.nix
    ./programs/git
    ./programs/nvim
    ./programs/password-store.nix
    ./programs/ripgrep.nix
    ./programs/ssh.nix
    ./programs/zsh
    ./services/syncthing.nix
    ./services/keybase.nix
  ];

  programs = {
    direnv = {
      enable = true;
      enableNixDirenvIntegration = true;
    };
    gpg = {
      enable = true;
      settings = { keyserver = "hkps://lorenz.leutgeb.xyz:443/"; };
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
    siji
    skaffold
    sshfs-fuse
    universal-ctags
    #nodejs
    #texlive.combined.scheme-full
    tailscale
    tmux
    travis
    tree
    xdotool
    yubikey-personalization
    yubioath-desktop
  ];
}
