{config, ...}: let
  port = "5000";
in {
  services = {
    harmonia = {
      enable = true;
      settings.bind = "[::]:${port}";
    };
    caddy = {
      virtualHosts."cache.${config.services.tailscale.baseDomain}" = {
        extraConfig = ''
          reverse_proxy :${port}
        '';
      };
    };
  };

  nix.settings.allowed-users = [config.systemd.services.harmonia.serviceConfig.User];
}
