{
  config,
  lib,
  ...
}: let
  domain = "bitwarden.leutgeb.xyz";
  libDir = "/var/lib/vaultwarden";
in {
  sops.secrets.vaultwarden = {
    sopsFile = ./sops/vaultwarden.env;
    format = "binary";
    owner = config.systemd.services.vaultwarden.serviceConfig.User;
  };

  #users.users.vaultwarden.extraGroups = [config.services.nullmailer.group];

  services = {
    vaultwarden = {
      enable = true;
      config = rec {
        DATA_FOLDER = libDir;
        DOMAIN = "https://${domain}";
        IP_HEADER = "X-Forwarded-For";
        PUSH_ENABLED = true;
        PUSH_IDENTITY_URI = "https://identity.bitwarden.eu";
        PUSH_RELAY_URI = "https://push.bitwarden.eu";
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
        SIGNUPS_ALLOWED = false;
        SMTP_FROM = "bitwarden@leutgeb.xyz";
        SMTP_USERNAME = "bitwarden@leutgeb.xyz";
        SMTP_FROM_NAME = "Bitwarden";
        SMTP_HOST = "smtp.migadu.com";
        SMTP_PORT = "465";
        SMTP_SECURITY = "force_tls";
        /*
        # https://discourse.nixos.org/t/nullmailer-and-systemd-services/41225
               USE_SENDMAIL = true;
               SENDMAIL_COMMAND = let
                 inherit (config.security) wrapperDir;
                 inherit (config.services.mail) sendmailSetuidWrapper;
               in "${wrapperDir}/${sendmailSetuidWrapper.program}";
        */
      };
      environmentFile = config.sops.secrets.vaultwarden.path;
    };
    caddy.virtualHosts.${domain}.extraConfig = ''
      reverse_proxy 127.0.0.1:${builtins.toString config.services.vaultwarden.config.ROCKET_PORT}
    '';
  };
  systemd.services = {
    vaultwarden.serviceConfig = {
      StateDirectory = lib.mkForce "vaultwarden";
      #ReadWritePaths = "/var/spool/nullmailer";
    };
    backup-vaultwarden.environment.DATA_FOLTER = lib.mkForce libDir;
  };
}
