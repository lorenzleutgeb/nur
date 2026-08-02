{
  config,
  pkgs,
  ...
}: let
  identityDomain = "salutas.org";
  domain = "id.${identityDomain}";
  nasDomain = "storage.${identityDomain}";
  port = 8553;
in {
  sops.secrets = {
    acme = {
      sopsFile = ./sops/acme.env;
      format = "binary";
    };
    "kanidm/oauth2/tailscale" = {
      sopsFile = ./sops/kanidm-tailscale.env;
      format = "binary";
      owner = "kanidm";
    };
    "kanidm/oauth2/nas" = {
      sopsFile = ./sops/kanidm-nas.env;
      format = "binary";
      owner = "kanidm";
    };
  };

  networking.firewall.allowedTCPPorts = [
    636 # LDAPS
  ];
  networking.hosts."127.0.0.1" = [domain];

  services = {
    caddy.virtualHosts = {
      ${domain}.extraConfig = ''
        @local_api {
          path /v1/*
          remote_ip 127.0.0.1 ::1
        }
        @public_api path_regexp ^/v1/(auth|self|credential|jwk|reauth|debug/ipinfo)

        handle @local_api {
          reverse_proxy https://127.0.0.1:${toString port} {
            transport http {
              # Kanidm is only reachable through this loopback connection.
              tls_insecure_skip_verify
            }
          }
        }

        handle @public_api {
          reverse_proxy https://127.0.0.1:${toString port} {
            transport http {
              # Kanidm is only reachable through this loopback connection.
              tls_insecure_skip_verify
            }
          }
        }

        handle /v1/* {
          respond 403
        }

        handle {
          reverse_proxy https://127.0.0.1:${toString port} {
            transport http {
              # Kanidm is only reachable through this loopback connection.
              tls_insecure_skip_verify
            }
          }
        }
      '';

      ${identityDomain}.extraConfig = ''
        redir /.well-known/webfinger https://${domain}/oauth2/openid/tailscale{uri} 307
      '';
    };

    kanidm = {
      server.enable = true;
      client.enable = true;
      package = pkgs.kanidmWithSecretProvisioning_1_10;

      server.settings = {
        domain = identityDomain;
        origin = "https://${domain}";

        bindaddress = "127.0.0.1:${toString port}";
        ldapbindaddress = "0.0.0.0:636";
        http_client_address_info.x-forward-for = ["127.0.0.1"];

        tls_chain = "/run/credentials/kanidm.service/cert.pem";
        tls_key = "/run/credentials/kanidm.service/key.pem";

        online_backup = {
          schedule = "3 */6 * * *";
          versions = 7;
        };
      };

      client.settings.uri = "https://${domain}";

      provision = {
        enable = true;
        groups = {
          nas_users.overwriteMembers = false;
          tailscale_users.overwriteMembers = false;
        };
        systems.oauth2 = {
          nas = {
            displayName = "Synology NAS";
            originUrl = "https://${nasDomain}";
            originLanding = "https://${nasDomain}";
            basicSecretFile = config.sops.secrets."kanidm/oauth2/nas".path;
            allowInsecureClientDisablePkce = true;
            enableLegacyCrypto = true;
            preferShortUsername = true;
            scopeMaps.nas_users = [
              "openid"
              "profile"
              "email"
            ];
          };
          tailscale = {
            displayName = "Tailscale";
            originUrl = "https://login.tailscale.com/a/oauth_response";
            originLanding = "https://login.tailscale.com/admin";
            basicSecretFile = config.sops.secrets."kanidm/oauth2/tailscale".path;
            scopeMaps.tailscale_users = [
              "openid"
              "profile"
              "email"
            ];
          };
        };
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
    certs.${domain}.postRun = ''
      systemctl try-restart kanidm.service
    '';
  };

  systemd.services.kanidm = {
    requires = ["acme-${domain}.service"];
    after = ["acme-${domain}.service"];
    serviceConfig.LoadCredential = let
      certs = config.security.acme.certs.${domain}.directory;
    in [
      "cert.pem:${certs}/fullchain.pem"
      "key.pem:${certs}/key.pem"
    ];
  };
}
