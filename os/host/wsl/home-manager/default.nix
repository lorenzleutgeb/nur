{ lib, pkgs, ... }:

with builtins;

{
  imports = [
    ../../../../home-manager/profiles/terminal.nix
    ../../../../home-manager/profiles/spass.nix
    ../../../../home-manager/profiles/programs/vscode.nix
  ];
}
