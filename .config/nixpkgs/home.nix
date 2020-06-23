{ config, pkgs, ... }:

let
  pkgsUnstable = import <nixpkgs-unstable> {};
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.03";

  home.packages = [
    pkgs.alacritty
    pkgs.fd
    pkgs.fortune
    pkgs.git
    pkgs.google-cloud-sdk
    pkgs.htop
    pkgs.neovim
    pkgs.xclip
    #pkgs.miv
    pkgsUnstable.nodejs
  ];
}
