{
  config,
  lib,
  ...
}: let
  tailnetName = "hs.leutgeb.xyz";
  tailscaleDns = "100.100.100.100";
in {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    permitCertUid = config.services.caddy.user;
  };

  networking.firewall = {
    trustedInterfaces = [config.services.tailscale.interfaceName];
    allowedUDPPorts = [config.services.tailscale.port];
  };


  systemd.network = {
  /*
    networks.${config.services.tailscale.interfaceName} = lib.mkIf config.systemd.network.enable {
      enable = true;
    name = config.services.tailscale.interfaceName;
    dns = [tailscaleDns];
    domains = [tailnetName];
  };
  */
  wait-online.ignoredInterfaces = [ config.services.tailscale.interfaceName ];
  };

  environment.etc."NetworkManager/dnsmasq.d/${tailnetName}.conf" = lib.mkIf (config.networking.networkmanager.dns == "dnsmasq") {
    text = ''
      server=/${tailnetName}/${tailscaleDns}
      server=${tailscaleDns}@${config.services.tailscale.interfaceName}
    '';
  };
}
