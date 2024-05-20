{config, ...}: let
  port = "38165";
  hostname = "ci.${config.services.tailscale.baseDomain}";
in {
  services.concourse-web = {
    enable = true;
    settings = {
      CONCOURSE_SESSION_SIGNING_KEY = "/etc/concourse/session_signing_key";
      CONCOURSE_TSA_HOST_KEY = "/etc/concourse/tsa_host_key";
      CONCOURSE_TSA_AUTHORIZED_KEYS = "/etc/concourse/authorized_worker_keys";
      CONCOURSE_ADD_LOCAL_USER = "lorenz:init";
      CONCOURSE_MAIN_TEAM_LOCAL_USER = "lorenz";
      CONCOURSE_BIND_PORT = port;
      CONCOURSE_EXTERNAL_URL = "https://${hostname}";
    };
  };

  services.caddy = {
    virtualHosts.${hostname} = {
      extraConfig = ''
        reverse_proxy :${port}
      '';
    };
  };
}
