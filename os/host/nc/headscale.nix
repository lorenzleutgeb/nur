{config, ...}: let
  apex = "leutgeb.xyz";
  sub = x: "${x}.${apex}";
  domain = sub "headscale";
in {
  services = {
    tailscale = {
      enable = true;
      interfaceName = "tailscale0";
      permitCertUid = config.services.caddy.user;
      useRoutingFeatures = "both";
    };

    headscale = {
      enable = true;
      address = "127.0.0.1";
      port = 8001;
      settings = {
        server_url = "https://${domain}";
        dns_config = {
          base_domain = sub "hs";
          nameservers = ["https://dns.nextdns.io/9bd4a2"];
          magic_dns = true;
        };
        logtail.enabled = false;
        ip_prefixes = [
          "100.96.0.0/12"
          "fd7a:115c:a1e0:e00::/56"
        ];
      };
    };

    caddy = {
      enable = true;
      virtualHosts."${domain}:443" = {
        useACMEHost = "${apex}-wildcard";
        listenAddresses = ["[::]"];
        extraConfig = ''
          reverse_proxy :${builtins.toString config.services.headscale.port}
        '';
      };
      virtualHosts."${sub "eleos"}:443" = {
        useACMEHost = "${apex}-wildcard";
        listenAddresses = ["[::]"];
        extraConfig = ''
          respond "Eleos"
        '';
      };
      /*
      extraConfig = ''
        import /var/lib/caddy/cloudflare
      '';
      */
    };
  };
  environment.systemPackages = [config.services.headscale.package];

  networking.firewall = {
    trustedInterfaces = [config.services.tailscale.interfaceName];
    allowedUDPPorts = [config.services.tailscale.port];
  };
}
