{ lib, pkgs, ... }:

with builtins;

{
  imports = [
    ./autorandr
    ../../../../home-manager/profiles/development.nix
    ../../../../home-manager/profiles/latex.nix
    ../../../../home-manager/profiles/gaming.nix
    ../../../../home-manager/profiles/spass.nix
    ../../../../home-manager/services/v4lbridge.nix
  ];

}
