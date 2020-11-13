{ lib, pkgs, ... }:

with builtins;

{
  imports = [
    ./wm/i3
    ./programs/autorandr.nix
    ./programs/bat
    ./programs/firefox
    ./programs/fzf.nix
    ./programs/gh.nix
    ./programs/git
    ./programs/nvim
    ./programs/ripgrep.nix
    ./programs/ssh.nix
    ./programs/zsh
  ];

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      enableNixDirenvIntegration = true;
    };
    gpg.enable = true;
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
    exa
    evince
    fd
    file
    fira-code
    fira-code-symbols
    fira-mono
    fontconfig
    font-awesome
    fzf
    ghcid
    glibcLocales
    googleearth
    google-cloud-sdk
    gource
    graphviz
    hlint
    htop
    insomnia
    jdk11
    jetbrains.idea-ultimate
    jq
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
    noto-fonts
    pandoc
    pinta
    pantheon.elementary-files
    pantheon.elementary-photos
    pavucontrol
    pdfgrep
    python38Full
    python38Packages.pip
    python38Packages.setuptools
    python38Packages.yamllint
    python38Packages.requests
    python38Packages.beautifulsoup4
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
    thunderbird
    teamviewer
    transmission-gtk
    universal-ctags
    #nodejs
    #texlive.combined.scheme-full
    tmux
    travis
    tree
    vlc
    wally-cli
    xclip
    xdotool
    yubioath-desktop
    yq
    zathura
  ];

  services = {
    flameshot.enable = true;
    syncthing = {
      enable = true;
      tray = true;
    };
  };

  fonts.fontconfig.enable = pkgs.lib.mkForce true;
}
