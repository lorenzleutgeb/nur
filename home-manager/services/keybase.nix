{ config, lib, pkgs, ... }: {
  services = {
    kbfs.enable = true;
    keybase.enable = true;
  };

  home.packages = [ pkgs.keybase-gui ];
}
