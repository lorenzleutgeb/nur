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
      preferredSeeds =
        [
          "z6MkjDYUKMUeY58Vtr8dGJrHRvnTfjKWVGCBYJDVTHXsXzm5@seed.radicle.at:8776"
          "z6MkrLMMsiPWUcNPHcRajuMi9mDfYckSoJyPwwnknocNYPm7@seed.radicle.garden:8776"
          "z6Mkmqogy2qEM2ummccUthFEaaHvyYmYBYh3dbe9W4ebScxo@ash.radicle.garden:8776"
          "z6MktrU3HB5hkin6M5PLbHn6GYD25yJH22zkJe9SqezmUcGm@seed.cloudhead.io:8776"
          "z6MkfXa53s1ZSFy8rktvyXt5ADCojnxvjAoQpzajaXyLqG5n@radicle.liw.fi:8776"
        ]
        ++ [
          "z6MkocYY4dgMjo2YeUEwQ4BP4AotL7MyovzJCPiEuzkjg127@${
            if tor.enable
            then "q37hn7rhcbqiirapcx5bkgxzue5oqijdmjv55anfht2ne5hxxjxyhhyd.onion"
            else "seed.leutgeb.xyz"
          }:8776"
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
