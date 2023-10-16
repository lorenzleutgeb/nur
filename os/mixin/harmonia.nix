{
  config,
  lib,
  ...
}: let
  port = "5000";
in {
  services.harmonia = {
    enable = true;
    settings.bind = "[::]:${port}";
  };

  nix.settings.allowed-users = [config.systemd.services.harmonia.serviceConfig.User];

  networking.firewall.allowedTCPPorts = [443];

  services.tailscale.permitCertUid = config.services.caddy.user;

  services.caddy = {
    enable = true;
    virtualHosts."${lib.tailscale.local}:443" = {
      listenAddresses = ["[::]"];
      extraConfig = ''
        handle_path /cache/* {
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
