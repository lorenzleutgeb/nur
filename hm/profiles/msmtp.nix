{
  pkgs,
  lib,
  config,
  ...
}: {
  accounts.email.accounts.lorenz = {
    primary = true;
    address = "lorenz.leutgeb@posteo.eu";
    userName = "lorenz.leutgeb@posteo.de";
    flavor = "posteo.de";
    realName = "Lorenz Leutgeb";
    passwordCommand = "${pkgs.coreutils}/bin/cat \"\${XDG_RUNTIME_DIR}/secrets/posteo\"";
    msmtp.enable = true;
  };

  programs.msmtp.enable = true;

  sops.secrets."posteo" = {};
}
