{
  config,
  lib,
  ...
}: let
  dns =
    # https://www.joindns4.eu/for-public
    (builtins.map (ip: "${ip}#unfiltered.joindns4.eu") [
      "2a13:1001::86:54:11:100"
      "2a13:1001::86:54:11:200"
      "86.54.11.100"
      "86.54.11.200"
    ])
    ++
    # https://quad9.net/service/service-addresses-and-features/#rec
    (builtins.map (ip: "${ip}#dns.quad9.net") [
      "2620:fe::fe"
      "2620:fe::9"
      "9.9.9.9"
      "149.112.112.112"
    ])
    ++
    # https://one.one.one.one/dns/
    (builtins.map (ip: "${ip}#one.one.one.one") [
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
      "1.1.1.1"
      "1.0.0.1"
    ]);
in {
  #systemd.services.systemd-resolved.serviceConfig.Environment = "SYSTEMD_LOG_LEVEL=debug";

  services = {
    resolved = {
      llmnr = "false";
      dnsovertls = "true";
      fallbackDns = dns;

      extraConfig = ''
        MulticastDNS=true
      '';
    };

    headscale.settings.dns_config = {
      base_domain = config.services.tailscale.baseDomain;
      #nameservers = ["https://dns.nextdns.io/${nextDns.id}"];
      magic_dns = true;
    };
  };
}
