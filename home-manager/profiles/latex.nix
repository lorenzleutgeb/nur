{ lib, pkgs, ... }:

with builtins;

{
  imports = [
    ../programs/bat
    ../programs/fzf.nix
    ../programs/gh.nix
    ../programs/git
    ../programs/nvim
    ../programs/ripgrep.nix
    ../programs/ssh.nix
    ../programs/zsh
  ];

  home.packages = with pkgs; [
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    bibtool
    entr
    envsubst
    fd
    file
    fira
    fira-code
    fira-code-symbols
    fira-mono
    fontconfig
    font-awesome
    fzf
    gnumake
    graphviz
    jq
    liberation_ttf
    mupdf
    neovim-remote
    niv
    nixfmt
    noto-fonts
    obsidian
    pandoc
    pdfgrep
    poppler_utils
    texlive.combined.scheme-full
    roboto
    roboto-mono
    roboto-slab
    wget
  ];
}
