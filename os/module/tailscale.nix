let
  tailnetName = "fluffy-ordinal.ts.net";
  nextDns = rec {
    id = "9bd4a2";
    hostname = "${id}.dns.nextdns.io.";
  };
in {
  services = {
    tailscale.enable = true;
    resolved = {
      enable = true;
      fallbackDns = (builtins.map (ip: "${ip}#${nextDns.hostname}") [
        "45.90.28.0"
        "2a07:a8c0::"
        "45.90.30.0"
        "2a07:a8c1::"
      ]) ++ [ "1.1.1.1#one.one.one.one." "1.1.1.1" ];
      extraConfig = ''
        DNSOverTLS=yes
      '';
    };
  };

  networking = {
    search = [ tailnetName ];
    firewall.trustedInterfaces = [ "tailscale0" ];
  };

  systemd = {
    services.systemd-resolved = {
      enable = true;
      #serviceConfig.Environment = "SYSTEMD_LOG_LEVEL=debug";
    };
    network = {
      enable = false; # TODO: Work out how networkd is compatible with WSL.
      networks."tailscale0" = {
        enable = true;
        name = "tailscale0";
        dns = [ "100.100.100.100" ];
        domains = [ tailnetName ];
      };
    };
  };
}
