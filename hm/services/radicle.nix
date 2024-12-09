{
  lib,
  osConfig,
  ...
}: let
  tor = osConfig.services.tor.client;
in {
  programs.radicle = {
    uri = {
      web-rad.enable = true;
      rad.browser.enable = true;
    };
    settings = {
      preferredSeeds = let
        seed = {
          key,
          hostname,
          port ? 8776,
        }: "${key}@${hostname}:${builtins.toString port}";
      in [
        (seed {
          key = "z6MkjDYUKMUeY58Vtr8dGJrHRvnTfjKWVGCBYJDVTHXsXzm5";
          hostname = "seed.radicle.at";
        })
        (seed {
          key = "z6MkrLMMsiPWUcNPHcRajuMi9mDfYckSoJyPwwnknocNYPm7";
          hostname = "seed.radicle.garden";
        })
        (seed {
          key = "z6Mkmqogy2qEM2ummccUthFEaaHvyYmYBYh3dbe9W4ebScxo";
          hostname = "ash.radicle.garden";
        })
        (seed {
          key = "z6MktrU3HB5hkin6M5PLbHn6GYD25yJH22zkJe9SqezmUcGm";
          hostname = "seed.cloudhead.io";
        })
        (seed {
          key = "z6MkfXa53s1ZSFy8rktvyXt5ADCojnxvjAoQpzajaXyLqG5n";
          hostname = "radicle.liw.fi";
        })
        (seed {
          key = "z6MksmpU5b1dS7oaqF2bHXhQi1DWy2hB7Mh9CuN7y1DN6QSz";
          hostname = "seed.radicle.xyz";
        })
        (seed {
          key = "z6MkocYY4dgMjo2YeUEwQ4BP4AotL7MyovzJCPiEuzkjg127";
          hostname =
            if tor.enable
            then "q37hn7rhcbqiirapcx5bkgxzue5oqijdmjv55anfht2ne5hxxjxyhhyd.onion"
            else "seed.leutgeb.xyz";
        })
      ];
      node.onion = lib.mkIf tor.enable {
        mode = "proxy";
        address = with tor.socksListenAddress; "${addr}:${builtins.toString port}";
      };
    };
  };
  services.radicle = {
    node = {
      enable = true;
      #lazy = true;
    };
    #httpd.enable = true;
  };
}
