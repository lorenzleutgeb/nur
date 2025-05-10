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
      llmnr = "false";
      dnsovertls = "true";
      fallbackDns = dns;
    };

    headscale.settings.dns_config = {
      base_domain = config.services.tailscale.baseDomain;
      nameservers = ["https://dns.nextdns.io/${nextDns.id}"];
      magic_dns = true;
    };
  };
}
