{
  pkgs,
  lib,
  ...
}: let
  tor = "127.0.0.1:9050";
in {
  # $ tailscale serve --bg --tcp 18081 tcp://localhost:18081

  services.monero = {
    enable = true;
    extraConfig = ''
      tx-proxy=tor,${tor},10
      proxy=${tor}

      # NOTE: Insecure if the RPC port gets
      # exposed beyond localhost or Tailscale!
      rpc-ssl=disabled
    '';
  };
}
