#pinentry-program /usr/bin/pinentry-curses
#pinentry-timeout 3600
#default-cache-ttl 3600
#no-allow-external-cache
{
  config,
  pkgs,
  ...
}: {
  programs = {
    gpg = {
      enable = true;
      settings = {keyserver = "hkps://lorenz.leutgeb.xyz:443/";};
    };
  };
}
