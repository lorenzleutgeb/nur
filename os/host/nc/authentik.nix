{config, ...}: let
  common = {
    enable = true;
    environmentFile = config.sops.secrets.authentik.path;
  };
in {
  sops.secrets.authentik = {
    sopsFile = ./sops/authentik.env;
    format = "binary";
  };

  services = {
    authentik = common;
    authentik-ldap = common;
    authentik-radius = common;
  };
}
