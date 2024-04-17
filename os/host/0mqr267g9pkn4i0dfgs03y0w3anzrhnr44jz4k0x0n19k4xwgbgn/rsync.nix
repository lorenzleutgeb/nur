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
      "global" = {
        "motd file" = builtins.toString (pkgs.writeText "rsync-motd" ''
          ${config.networking.hostName} running NixOS ${config.system.nixos.release} @ ${self.shortRev or self.dirtyShortRev}
        '');
        address = "100.96.0.4";
      };
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
