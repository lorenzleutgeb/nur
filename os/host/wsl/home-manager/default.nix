{ lib, pkgs, ... }:

with builtins;

{
  imports = [
    ../../../../home-manager/profiles/terminal.nix
    ../../../../home-manager/profiles/spass.nix
    ../../../../home-manager/programs/vscode.nix
    ../../../../home-manager/profiles/latex.nix
    ../../../../home-manager/profiles/wsl.nix
    ../../../../home-manager/profiles/mpi-klsb.nix
  ];
}
