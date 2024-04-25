{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  sops.secrets = {
    "cloudflare/api/token".sopsFile = ./sops/cloudflare.yaml;
  };

  services.caddy = {
    globalConfig = ''
      acme_dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    '';

    virtualHosts = {
      "http://".extraConfig = "respond \"Servus! ${self.rev or self.dirtyRev} ${self.lastModifiedDate}\"";
      "falsum.org" = {
        serverAliases = ["www.falsum.org"];
        extraConfig = ''
          root * /var/www/falsum.org
          file_server
        '';
      };
      "lorenz.leutgeb.wien" = {
        extraConfig = ''
          root * /var/www/lorenz.leutgeb.wien
          file_server
        '';
      };
      "pad.leutgeb.wien" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:${builtins.toString config.services.hedgedoc.settings.port}
        '';
      };
    };
  };

  systemd.services.caddy.serviceConfig = {
    LoadCredential = "CLOUDFLARE_API_TOKEN:${config.sops.secrets."cloudflare/api/token".path}";
    RuntimeDirectory = "caddy";
    ExecStartPre = lib.mkForce [
      ''${config.services.caddy.package}/bin/caddy validate --config ${config.services.caddy.configFile} ${lib.optionalString (config.services.caddy.adapter != null) "--adapter ${config.services.caddy.adapter}"}''

      ((pkgs.writeShellApplication {
          name = "caddy-secrets";
          text = "echo \"CLOUDFLARE_API_TOKEN=\\\"$(<\"$CREDENTIALS_DIRECTORY/CLOUDFLARE_API_TOKEN\")\\\"\" > \"$RUNTIME_DIRECTORY/secrets.env\"";
        })
        + "/bin/caddy-secrets")
    ];
    EnvironmentFile = "-%t/caddy/secrets.env";
  };
}
