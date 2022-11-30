{ lib, pkgs, ... }:

with builtins;

{
  imports = [
    ../../../../home-manager/profiles/terminal.nix
    ../../../../home-manager/profiles/spass.nix
    ../../../../home-manager/programs/vscode.nix
  ];
}
