{
  config,
  pkgs,
  ...
}: let
  cfg = config.services.nextcloud;
  fpm = config.services.phpfpm.pools.nextcloud;
in {
  sops.secrets."nextcloud/admin" = {
    sopsFile = ./sops/nextcloud.yaml;
    owner = "nextcloud";
    group = "nextcloud";
  };

  services.postgresql.package = pkgs.postgresql_15;

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud28;
    hostName = "cloud.leutgeb.xyz";

    caching.redis = true;
    configureRedis = true;

    database.createLocally = true;

    datadir = "/mnt/share/nextcloud";

    config = {
      dbtype = "pgsql";
      adminpassFile = config.sops.secrets."nextcloud/admin".path;
    };
  };

  services.caddy = {
    enable = mkDefault true;
    virtualHosts."${
      if cfg.https
      then "https"
      else "http"
    }://${cfg.hostName}" = {
      extraConfig = ''
        encode zstd gzip

        root * ${config.services.nginx.virtualHosts.${cfg.hostName}.root}

        redir /.well-known/carddav /remote.php/dav 301
        redir /.well-known/caldav /remote.php/dav 301
        redir /.well-known/* /index.php{uri} 301
        redir /remote/* /remote.php{uri} 301

        header {
          Strict-Transport-Security max-age=31536000
          Permissions-Policy interest-cohort=()
          X-Content-Type-Options nosniff
          X-Frame-Options SAMEORIGIN
          Referrer-Policy no-referrer
          X-XSS-Protection "1; mode=block"
          X-Permitted-Cross-Domain-Policies none
          X-Robots-Tag "noindex, nofollow"
          -X-Powered-By
        }

        php_fastcgi unix/${fpm.socket} {
          root ${config.services.nginx.virtualHosts.${cfg.hostName}.root}
          env front_controller_active true
          env modHeadersAvailable true
        }

        @forbidden {
          path /build/* /tests/* /config/* /lib/* /3rdparty/* /templates/* /data/*
          path /.* /autotest* /occ* /issue* /indie* /db_* /console*
          not path /.well-known/*
        }
        error @forbidden 404

        @immutable {
          path *.css *.js *.mjs *.svg *.gif *.png *.jpg *.ico *.wasm *.tflite
          query v=*
        }
        header @immutable Cache-Control "max-age=15778463, immutable"

        @static {
          path *.css *.js *.mjs *.svg *.gif *.png *.jpg *.ico *.wasm *.tflite
          not query v=*
        }
        header @static Cache-Control "max-age=15778463"

        @woff2 path *.woff2
        header @woff2 Cache-Control "max-age=604800"

        file_server
      '';
    };
  };
}
