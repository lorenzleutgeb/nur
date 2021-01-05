{ lib, pkgs, ... }:

with builtins;

{
  home.file.".yubico/authorized_yubikeys".text = "lorenz:ccccccdubtre";
}
