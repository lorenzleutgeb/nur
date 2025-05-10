{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  inherit (builtins) toString;

  inherit (lib) mkIf optional;

  port = 8776;
  tor =
    osConfig.services.tor.client
    // {
      # TODO: Depends on Tor running on the system.
      # sudo -u tor cat /var/lib/tor/onion/radicle/hostname
      address = "x3usylutxxwujquc4dut44krigmbmfxqgeyz2duoqkjiocvrmzwoxtad.onion:${toString port}";
    };
  ygg =
    osConfig.services.yggdrasil
    // {
      # TODO: Depends on Yggdrasil running on the system.
      # sudo -u yggdrasil yggdrasilctl getSelf
      address = "[200:eb97:1e08:d417:b4a2:806f:9502:b7d7]:${toString port}";
    };
in {
  home.packages = with pkgs; [
    python3Packages.zulip # for rad-zulip
  ];

  programs.radicle = {
    uri = {
      web-rad.enable = false;
      rad.browser.enable = false;
    };
    settings.node = {
      connect = let
        connectAddr = {
          nid,
          addr,
          port ? 8776,
        }: "${nid}@${addr}:${toString port}";
      in
        [
          (connectAddr {
            nid = "z6MksmpU5b1dS7oaqF2bHXhQi1DWy2hB7Mh9CuN7y1DN6QSz";
            addr = "seed.radicle.xyz";
          })
        ]
        ++ (
          let
            nid = "z6MkocYY4dgMjo2YeUEwQ4BP4AotL7MyovzJCPiEuzkjg127";
          in
            (optional tor.enable (connectAddr {
              inherit nid;
              addr = "q37hn7rhcbqiirapcx5bkgxzue5oqijdmjv55anfht2ne5hxxjxyhhyd.onion";
            }))
            ++ (optional ygg.enable (connectAddr {
              inherit nid;
              addr = "[202:f094:502b:1b03:9e0:2c3d:bc8b:428b]";
            }))
            ++ (optional (!ygg.enable && !tor.enable) (connectAddr {
              inherit nid;
              addr = "seed.leutgeb.xyz";
            }))
        );
      onion = mkIf tor.enable {
        mode = "proxy";
        address = with tor.socksListenAddress; "${addr}:${toString port}";
      };
      /*
      externalAddresses =
        (optional tor.enable tor.address)
        ++ (optional ygg.enable ygg.address);
      listen =
        optional ygg.enable ygg.address;
	++ (optional tor.enable "[::1]:${toString port}");
      */
    };
  };
  services.radicle = {
    node = {
      enable = true;
      lazy = false;
    };
    #httpd.enable = true;
  };
}
