{
  config,
  pkgs,
  ...
}: let
  domain = {
    internal = "hs.leutgeb.xyz";
    external = "headscale.leutgeb.xyz";
  };
in {
  environment.systemPackages = [config.services.headscale.package];

  users.users.lorenz.extraGroups = [config.services.headscale.group];

  systemd.services = {
    "tailscaled" = {
      wants = ["headscale.service"];
      after = ["headscale.service"];
    };
  };

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
        server_url = "https://${domain.internal}";
        logtail.enabled = false;
        ip_prefixes = [
          "100.96.0.0/12"
          "fd7a:115c:a1e0:e00::/56"
        ];
      };
    };

    caddy.virtualHosts."${domain.external}" = {
      serverAliases = [domain.internal];
      extraConfig = ''
        reverse_proxy :${builtins.toString config.services.headscale.port}
      '';
    };
  };
}
