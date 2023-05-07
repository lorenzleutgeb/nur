let tailnetName = "fluffy-ordinal.ts.net";
in {
  services = {
    tailscale.enable = true;
    resolved = {
      enable = true;
      extraConfig = ''
        DNSOverTLS=yes
      '';
    };
  };

  networking = { firewall.trustedInterfaces = [ "tailscale0" ]; };

  systemd = {
    services.systemd-resolved = {
      enable = true;
      #serviceConfig.Environment = "SYSTEMD_LOG_LEVEL=debug";
    };
    network = {
      enable = true;
      networks."tailscale0" = {
        enable = true;
        name = "tailscale0";
        dns = [ "100.100.100.100" ];
        domains = [ tailnetName ];
      };
    };
  };
}
