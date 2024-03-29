{lib, ...}: let
  hosts = {
    "0mqr" = {
      pub = ../host/0mqr267g9pkn4i0dfgs03y0w3anzrhnr44jz4k0x0n19k4xwgbgn/ssh_host_ed25519_key.pub;
      ip = "10.96.0.4";
    };
  };
in {
  programs.ssh.knownHosts =
    builtins.mapAttrs (n: v: {
      extraHostNames = [v.ip];
      publicKeyFile = v.pub;
    })
    hosts;
}
