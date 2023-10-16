{
  config,
  pkgs,
  ...
}: let
  domain = "hs.leutgeb.xyz";
in {
  environment.systemPackages = [config.services.headscale.package];

  users.users.lorenz.extraGroups = [config.services.headscale.group];

  services = {
    headscale = {
      enable = true;
      address = "127.0.0.1";
      port = 8001;
      settings = {
        acl_policy_path = pkgs.writeText "acls.hujson" (
          builtins.toJSON {
            acls = [
              {
                action = "accept";
                src = ["*"];
                dst = ["*:*"];
              }
            ];
          }
        );
        server_url = "https://${domain}";
        logtail.enabled = false;
        ip_prefixes = [
          "100.96.0.0/12"
          "fd7a:115c:a1e0:e00::/56"
        ];
      };
    };

    caddy.virtualHosts."${domain}:443" = {
      listenAddresses = ["[::]"];
      extraConfig = ''
        reverse_proxy :${builtins.toString config.services.headscale.port}
      '';
    };
  };
}
