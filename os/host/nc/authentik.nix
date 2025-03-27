{config, ...}: let
  hostname = "auth.salutas.org";
  common = {
    enable = true;
    environmentFile = config.sops.secrets.authentik.path;
  };
in {
  sops.secrets.authentik = {
    sopsFile = ./sops/authentik.env;
    format = "binary";
  };

  sops.secrets.authentik-ldap = {
    sopsFile = ./sops/authentik-ldap.env;
    format = "binary";
  };

  sops.secrets.authentik-radius = {
    sopsFile = ./sops/authentik.env;
    format = "binary";
  };

  services = {
    caddy.virtualHosts.${hostname}.extraConfig = ''
      reverse_proxy 127.0.0.1:9000
    '';

    authentik = {
      enable = true;
      environmentFile = config.sops.secrets.authentik.path;
    };
    authentik-ldap = {
      enable = true;
      environmentFile = config.sops.secrets.authentik-ldap.path;
    };
    authentik-radius = {
      enable = false;
      environmentFile = config.sops.secrets.authentik-radius.path;
    };
  };
}
