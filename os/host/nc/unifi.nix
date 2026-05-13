{pkgs, ...}: {
  services = {
    caddy.virtualHosts = {
      "unifi.leutgeb.xyz".extraConfig = ''
        reverse_proxy https://127.0.0.1:8443 {
          header_up Host localhost:8443
          header_up Origin https://localhost:8443
          header_up Referer https://localhost:8443/
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
      "http://127.0.0.1:9080".extraConfig = ''
        @manifest {
          path /api/ucore/manifest
        }

        handle @manifest {
          header Content-Type application/json
          respond "{}" 200
        }

        handle {
          respond "" 401
        }
      '';
    };
    unifi = {
      enable = true;
      openFirewall = true;
      unifiPackage = pkgs.unifi;
      mongodbPackage = pkgs.mongodb-ce;
      maximumJavaHeapSize = 1024;
      initialJavaHeapSize = 128;
    };
  };
}
