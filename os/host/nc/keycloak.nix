{...}: let
  domain = "salutas.org";
  hostname = "id.${domain}";
  port = 7000;
in {
  services = {
    nginx.virtualHosts.${hostname} = {
      onlySSL = true;
      useACMEHost = "${domain}-wildcard";
      locations."/".extraConfig = ''
        proxy_pass http://localhost:${builtins.toString port};
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header X-Forwarded-Host ${hostname};
      '';
    };

    caddy.virtualHosts.${hostname}.extraConfig = ''
      reverse_proxy 127.0.0.1:${builtins.toString port}
    '';

    keycloak = {
      enable = true;
      initialAdminPassword = "saarbruck";
      database.passwordFile = "/etc/keycloak/db";
      settings = {
        inherit hostname;
        http-host = "localhost";
        http-port = port;
        http-enabled = true;
        #proxy = "edge";
        proxy-headers = "xforwarded";
        hostname-strict = true;
        #hostname-url = "https://${hostname}";
        hostname-admin-url = "https://${hostname}";
        #features = "declarative-user-profile";
      };
    };
  };
  #systemd.services.keycloak.environment.KC_FEATURES = "declarative-user-profile";
}
