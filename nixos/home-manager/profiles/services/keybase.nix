{ config, lib, pkgs, ...}:
{
  services = {
    kbfs.enable = true;
    keybase.enable = true;
  };

  home.packages = lib.optionals (pkgs.stdenv.isx86_64) [
    pkgs.keybase-gui
  ];
}
