{
  config,
  lib,
  ...
}: let
  tailscaleDns = "100.100.100.100";
  tailnetName = config.services.tailscale.baseDomain;
in {
  options = {
    services.tailscale = {
      nodeName = lib.mkOption {
        type = lib.types.str;
        default = builtins.substring 0 4 config.networking.hostName;
      };
      namespace = lib.mkOption {
        type = lib.types.str;
      };
      baseDomain = lib.mkOption {
        type = lib.types.str;
        default = config.networking.domain;
      };
    };
  };

  config = {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "both";
      permitCertUid = config.services.caddy.user;
      baseDomain = "hs.leutgeb.xyz";
      namespace = "lorenz";
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
      wait-online.ignoredInterfaces = [config.services.tailscale.interfaceName];
    };

    environment.etc."NetworkManager/dnsmasq.d/${tailnetName}.conf" = lib.mkIf (config.networking.networkmanager.dns == "dnsmasq") {
      text = ''
        server=/${tailnetName}/${tailscaleDns}
        server=${tailscaleDns}@${config.services.tailscale.interfaceName}
      '';
    };

    /*
    programs.ssh.knownHosts = lib.pipe ["0mqr"] [
      lib.tailscale.host
      (name: {
        extraHostNames = [name];
      })
    ];
    */
  };
}
