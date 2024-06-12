{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  static = domain: {
    ${domain} = {
      extraConfig = ''
        root * /var/www/${domain}
        encode zstd gzip
        file_server
      '';
    };
  };
in {
  networking.firewall = {
    allowedUDPPorts = [443];
    allowedTCPPorts = [80 443];
  };
  services.caddy = {
    enable = true;
    email = "lorenz.leutgeb@gmail.com";
    virtualHosts =
      {
        "http://".extraConfig = "respond `${builtins.toJSON {
          rev = self.rev or self.dirtyRev;
          inherit (self) lastModified;
        }}`";
      }
      // (static "lorenz.leutgeb.wien")
      // (static "lorenz.leutgeb.xyz")
      // (static "falsum.org");
  };
}
