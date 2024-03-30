{
  config,
  lib,
  ...
}: let
  port = "5001";
in {
  services.radicle = {
    enable = false;
    httpd.args = "--listen 127.0.0.1:${port}";
  };

  networking.firewall.allowedTCPPorts = [443];

  services.tailscale.permitCertUid = config.services.caddy.user;

  services.caddy = {
    enable = true;
    virtualHosts."seed.leutgeb.xyz:443" = {
      listenAddresses = ["[::]"];
      extraConfig = ''
        handle_path /* {
          reverse_proxy :${port}
        }
        tls {
          dns cloudflare {env.CLOUDFLARE_API_TOKEN}
          resolvers 1.1.1.1
        }
        encode zstd
      '';
    };
  };
}
