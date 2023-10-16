{
  lib,
  config,
  ...
}: {
  tailscale = let
    cfg = config.services.tailscale;
  in rec {
    host = x: "${x}.${cfg.namespace}.${cfg.baseDomain}";
    local = host cfg.nodeName;
  };
}
