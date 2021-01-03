{ config, pkgs, ... }:

{
  programs = {
    gpg = {
      enable = true;
      settings = { keyserver = "hkps://lorenz.leutgeb.xyz:443/"; };
    };
  };

}
