{ config, lib, ... }:

let
  useDnsmasq = config.networking.networkmanager.dns == "dnsmasq";
  nextDns = rec {
    id = "9bd4a2";
    hostname = "${id}.dns.nextdns.io";
  };
  dns = (builtins.map (ip: "${ip}#${nextDns.hostname}") [
    "45.90.28.0"
    "2a07:a8c0::"
    "45.90.30.0"
    "2a07:a8c1::"
  ]) ++ [ "1.1.1.1#one.one.one.one" ];
in {
  systemd.services.systemd-resolved = {
    #serviceConfig.Environment = "SYSTEMD_LOG_LEVEL=debug";
  };

  services.resolved = {
    fallbackDns = dns;
    extraConfig = ''
      DNSOverTLS=yes
    '';
  };

  environment.etc."NetworkManager/dnsmasq.d/cloudflare.conf" =
    lib.mkIf useDnsmasq { text = "server=1.1.1.1"; };

  environment.etc."NetworkManager/dnsmasq.d/interface.conf" =
    lib.mkIf useDnsmasq { text = "interface=lo"; };
}
