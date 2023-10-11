{
  config,
  lib,
  pkgs,
  ...
}: {
  sops.secrets = {
    "cloudflare/api/token".sopsFile = ./sops/cloudflare.yaml;
  };

  services.caddy = {
    enable = true;
    globalConfig = ''
      email lorenz.leutgeb@gmail.com
      acme_dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    '';
  };

  systemd.services.caddy.serviceConfig = {
    LoadCredential = "CLOUDFLARE_API_TOKEN:${config.sops.secrets."cloudflare/api/token".path}";
    RuntimeDirectory = "caddy";
    ExecStartPre = lib.mkForce [
      ''${config.services.caddy.package}/bin/caddy validate --config ${config.services.caddy.configFile} ${lib.optionalString (config.services.caddy.adapter != null) "--adapter ${config.services.caddy.adapter}"}''

      ((pkgs.writeShellApplication rec {
          name = "caddy-secrets";
          text = "echo \"CLOUDFLARE_API_TOKEN=\\\"$(<\"$CREDENTIALS_DIRECTORY/CLOUDFLARE_API_TOKEN\")\\\"\" > \"$RUNTIME_DIRECTORY/secrets.env\"";
        })
        + "/bin/caddy-secrets")
    ];
    EnvironmentFile = "-%t/caddy/secrets.env";
  };
}
