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
  sops.secrets."acme-secret" = {
    sopsFile = ./sops/acme-secret;
    format = "binary";
  };

  networking.firewall = {
    allowedUDPPorts = [443];
    allowedTCPPorts = [80 443];
  };

  services.nginx.enable = lib.mkForce false;

  services.caddy = {
    enable = true;
    email = "lorenz.leutgeb@posteo.de";
    /*
    package = pkgs.caddy.withPlugins {
      plugins = ["github.com/caddy-dns/rfc2136@v0.2.0"];
      hash = "sha256-W9tl+BGHSlPDBcMOQ3G1wTk7DTUSrQC2A7KB4wsf3OI=";
    };
    */
    virtualHosts =
      {
        "http://".extraConfig = "respond `${builtins.toJSON {
          rev = self.rev or self.dirtyRev;
          inherit (self) lastModified;
        }}`";
      }
      // (static "lorenz.leutgeb.wien")
      // (static "lorenz.leutgeb.xyz")
      // (static "falsum.org")
      // (static "salutas.org");
    /*
    extraConfig = ''
      acme_dns rfc2136 {
        key_name "acme"
        key_alg "hmac-sha256"
        key {file.${config.sops.secrets."acme-secret".path}}
        server "127.0.0.1:53"
      }
    '';
    */
  };
}
