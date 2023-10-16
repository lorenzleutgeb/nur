{
  config,
  lib,
  ...
}: let
  nextDns = rec {
    id = "9bd4a2";
    hostname = "${id}.dns.nextdns.io";
  };
  dns =
    (builtins.map (ip: "${ip}#${nextDns.hostname}") [
      "45.90.28.0"
      "2a07:a8c0::"
      "45.90.30.0"
      "2a07:a8c1::"
    ])
    ++ ["1.1.1.1#one.one.one.one"];
in {
  #systemd.services.systemd-resolved.serviceConfig.Environment = "SYSTEMD_LOG_LEVEL=debug";

  services = {
    resolved = {
      fallbackDns = dns;
      extraConfig = "DNSOverTLS=yes";
    };

    headscale.settings.dns_config = {
      base_domain = config.services.tailscale.baseDomain;
      nameservers = ["https://dns.nextdns.io/${nextDns.id}"];
      magic_dns = true;
    };
  };

  environment.etc = lib.mkIf (config.networking.networkmanager.dns == "dnsmasq") {
    "NetworkManager/dnsmasq.d/cloudflare.conf".text = "server=1.1.1.1";
    "NetworkManager/dnsmasq.d/interface.conf".text = "interface=lo";
  };
}
