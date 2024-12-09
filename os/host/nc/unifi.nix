{pkgs, ...}: {
  services = {
    caddy.virtualHosts = {
      "unifi.leutgeb.xyz".extraConfig = ''
             reverse_proxy :8443 {
               transport http {
          tls_insecure_skip_verify
        }
             }
      '';
      "portal.leutgeb.xyz".extraConfig = ''
             reverse_proxy :8843 {
               transport http {
          tls_insecure_skip_verify
        }
             }
      '';
      "http://unifi.leutgeb.xyz".extraConfig = ''
        handle /inform {
          reverse_proxy :8080
        }
        handle / {
          redir https://{host} permanent
        }
        respond "?"
      '';
    };
    unifi = {
      enable = true;
      openFirewall = true;
      unifiPackage = pkgs.unifi;
      mongodbPackage = pkgs.mongodb-ce;
    };
  };
}
