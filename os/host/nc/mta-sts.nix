{pkgs, ...}: let
  domains = [
    "leutgeb.xyz"
    "leutgeb.wien"
    "falsum.org"
  ];
in {
  services.caddy.virtualHosts = builtins.listToAttrs (map (
      domain: {
        name = "mta-sts.${domain}";
        value.extraConfig = ''
          handle /.well-known/mta-sts.txt {
            header Content-Type "text/plain; charset=utf-8"
            respond "version: STSv1
          mode: enforce
          mx: *.migadu.com
          max_age: 604800
          "
          }
        '';
      }
    )
    domains);
}
