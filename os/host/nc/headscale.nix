{config, ...}: let
  apex = "leutgeb.xyz";
  sub = x: "${x}.${apex}";
  domain = sub "headscale";
in {
  services = {
    headscale = {
      enable = true;
      address = "0.0.0.0";
      port = 8001;
      settings = {
        server_url = "https://${domain}";
        dns_config.base_domain = apex;
        logtail.enabled = false;
      };
    };

    caddy = {
      enable = true;
      virtualHosts."${domain}:443" = {
        listenAddresses = ["[::]"];
        extraConfig = ''
          reverse_proxy :${builtins.toString config.services.headscale.port}
        '';
      };
      virtualHosts."${sub "eleos"}:443" = {
        listenAddresses = ["[::]"];
        extraConfig = ''
          respond "Eleos"
        '';
      };
      extraConfig = ''
        import /var/lib/caddy/cloudflare
      '';
    };
  };
  environment.systemPackages = [config.services.headscale.package];
}
