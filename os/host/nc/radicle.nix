{
  config,
  lib,
  pkgs,
  ...
}: let
  onion = "q37hn7rhcbqiirapcx5bkgxzue5oqijdmjv55anfht2ne5hxxjxyhhyd.onion";
in {
  services.radicle = {
    enable = true;
    privateKeyFile = "/etc/ssh/ssh_host_ed25519_key";
    publicKey = "/etc/ssh/ssh_host_ed25519_key.pub";
    settings.node = {
      alias = "leutgeb.xyz";
      externalAddresses = [
        "seed.leutgeb.xyz:8776"
        "${onion}:8776"
      ];
    };
  };
}
