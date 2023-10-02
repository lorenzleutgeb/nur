{config, ...}: let
  port = "5000";
in {
  services.harmonia = {
    enable = true;
    settings.bind = "[::]:${port}";
  };

  nix.settings.allowed-users = ["harmonia"];

  networking.firewall.allowedTCPPorts = [443];

  services.tailscale.permitCertUid = config.services.caddy.user;

  services.caddy = {
    enable = true;
    virtualHosts."0mqr.fluffy-ordinal.ts.net:443" = {
      listenAddresses = ["[::]"];
      extraConfig = ''
        handle_path /cache/* {
          reverse_proxy :${port}
        }
        encode zstd
      '';
    };
  };
}
