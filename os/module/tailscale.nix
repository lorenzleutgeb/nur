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
      domains = [ tailnetName ];
      fallbackDns = builtins.map (ip: "${ip}#${nextDns.hostname}") [
        "45.90.28.0"
        "2a07:a8c0::"
        "45.90.30.0"
        "2a07:a8c1::"
      ];
      extraConfig = ''
        DNSOverTLS=yes
      '';
    };
  };

  networking = {
    search = [ tailnetName ];
    firewall.trustedInterfaces = [ "tailscale0" ];
  };
}
