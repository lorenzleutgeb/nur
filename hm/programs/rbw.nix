{
  pkgs,
  lib,
  ...
}: let
  part = "lorenz.leutgeb";
  at = "@";
  common = {
    pinentry = lib.getExe pkgs.pinentry-tty;
    email = "${part}${at}posteo.eu";
    sync_interval = 60 * 30;
    lock_timeout = 60 * 15;
  };
in {
  programs.rbw.enable = true;

  xdg.configFile."rbw-salutas/config.json".text = builtins.toJSON (common
    // {
      base_url = "https://bitwarden.salutas.org";
      email = "lorenz${at}leutgeb.xyz";
    });

  xdg.configFile."rbw-radicle/config.json".text = builtins.toJSON common;

  home.shellAliases.bw = "rbw";
}
