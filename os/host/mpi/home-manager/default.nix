{ lib, pkgs, ... }:

with builtins;

{
  imports = [
    ../../../../home-manager/profiles/terminal.nix
    ../../../../home-manager/profiles/services/v4lbridge.nix
  ];

}
