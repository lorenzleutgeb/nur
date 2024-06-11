{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  services.caddy = {
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
      "lorenz.leutgeb.xyz" = {
        serverAliases = ["http://lorenz.leutgeb.xyz"]; # For testing.
        extraConfig = ''
          root * /var/www/lorenz.leutgeb.xyz
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
}
