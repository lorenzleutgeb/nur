{ config, lib, ... }:

let
  tailnetName = "fluffy-ordinal.ts.net";
  tailscaleDns = "100.100.100.100";
in {
  services.tailscale.enable = true;

  networking.firewall.trustedInterfaces =
    [ config.services.tailscale.interfaceName ];

  systemd.network.networks.${config.services.tailscale.interfaceName} =
    lib.mkIf config.systemd.network.enabled {
      enable = true;
      name = config.services.tailscale.interfaceName;
      dns = [ tailscaleDns ];
      domains = [ tailnetName ];
    };

  environment.etc."NetworkManager/dnsmasq.d/${tailnetName}.conf" =
    lib.mkIf (config.networking.networkmanager.dns == "dnsmasq") {
      text = ''
        server=/${tailnetName}/${tailscaleDns}
        server=${tailscaleDns}@${config.services.tailscale.interfaceName}
      '';
    };
}
