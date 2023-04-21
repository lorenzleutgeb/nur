{ lib, pkgs, ... }:

with builtins;

{
  home.packages = with pkgs; [
    aspell
    aspellDicts.de
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    bibtool
    entr
    envsubst
    fira
    fira-code
    fira-code-symbols
    fira-mono
    fontconfig
    font-awesome
    gnumake
    liberation_ttf
    mupdf
    noto-fonts
    pandoc
    pdfgrep
    poppler_utils
    texlive.combined.scheme-full
    roboto
    roboto-mono
    roboto-slab
  ];
}
