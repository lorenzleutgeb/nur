{config, ...}: let
  domain = "pad.leutgeb.wien";
in {
  services = {
    hedgedoc = {
      enable = true;
      settings = {
        inherit domain;
      };
    };

    caddy.virtualHosts."pad.leutgeb.wien".extraConfig = ''
      reverse_proxy 127.0.0.1:${builtins.toString config.services.hedgedoc.settings.port}
    '';
  };
}
