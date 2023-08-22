let
  hosts = {
    wsl = {
      pub = ../host/wsl/ssh_host_ed25519_key.pub;
      ip = "100.77.178.34";
    };
    "0mqr" = {
      pub = ../host/0mqr267g9pkn4i0dfgs03y0w3anzrhnr44jz4k0x0n19k4xwgbgn/ssh_host_ed25519_key.pub;
      ip = "100.85.40.10";
    };
  };
  tailnet = "fluffy-ordinal";
in {
  programs.ssh.knownHosts =
    builtins.mapAttrs (n: v: {
      extraHostNames = [v.ip "${n}.${tailnet}.ts.net"];
      publicKeyFile = v.pub;
    })
    hosts;
}
