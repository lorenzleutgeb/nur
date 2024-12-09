{
  config,
  pkgs,
  self,
  ...
}: {
  systemd.services."rsyncd" = {
    after = ["tailscaled.service"];
    bindsTo = ["tailscaled.service"];
  };
  services.rsyncd = let
    inherit (config.users.users.lorenz) home uid;
  in {
    enable = true;
    settings = {
      "global"."motd file" = "/etc/motd";
      "DCIM" = {
        inherit uid;
        path = "${home}/sync/p6a/DCIM";
        "read only" = false;
      };
      "Downloads" = {
        inherit uid;
        path = "${home}/Downloads";
        "read only" = false;
      };
      "Signal" = {
        inherit uid;
        path = "${home}/.backup/signal";
        "read only" = false;
        "write only" = true;
      };
    };
  };
}
