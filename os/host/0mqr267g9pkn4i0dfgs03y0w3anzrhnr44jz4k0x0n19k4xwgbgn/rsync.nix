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
  services.rsyncd = {
    enable = true;
    settings = {
      "global"."motd file" = "/etc/motd";
      "DCIM" = {
        path = config.users.users.lorenz.home + "/sync/p6a/DCIM";
        uid = config.users.users.lorenz.uid;
        "read only" = false;
      };
      "Signal" = {
        path = config.users.users.lorenz.home + "/.backup/signal";
        uid = config.users.users.lorenz.uid;
        "read only" = false;
        "write only" = true;
      };
    };
  };
}
