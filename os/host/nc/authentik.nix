{config, ...}: let
  hostname = "auth.salutas.org";
  common = {
    enable = true;
    environmentFile = config.sops.secrets.authentik.path;
  };
in {
  sops.secrets.acme = {
    sopsFile = ./sops/acme.env;
    format = "binary";
  };

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

  networking.firewall.allowedTCPPorts = [
    636 # ldaps
  ];

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

    ghostunnel = {
      enable = true;
      servers."authentik-ldaps" = {
        target = "127.0.0.1:6636";
        listen = "0.0.0.0:636";
        disableAuthentication = true;
        cert = config.security.acme.certs."auth.salutas.org".directory + "/fullchain.pem";
        key = config.security.acme.certs."auth.salutas.org".directory + "/key.pem";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "lorenz.leutgeb@posteo.eu";
      dnsProvider = "rfc2136";
      environmentFile = config.sops.secrets.acme.path;
    };
    certs."auth.salutas.org" = {};
  };
}
