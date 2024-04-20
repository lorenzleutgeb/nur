{pkgs, ...}: let
  what = "0mqr.lorenz.hs.leutgeb.xyz:/mnt/share";
  where = "/mnt/share";
in {
  environment.systemPackages = [pkgs.nfs-utils];
  services = {
    rpcbind.enable = true;
    cachefilesd.enable = true;
  };
  systemd = {
    mounts = [
      {
        inherit what where;
        type = "nfs";
        wantedBy = ["remote-fs.target"];
        mountConfig.Options = "rw,noatime,hard,intr,fsc,noexec,nosuid,nodev";
        unitConfig = {
          After = ["rpcbind.target" "network.target" "sys-subsystem-net-devices-tailscale0.device"];
          BindsTo = ["sys-subsystem-net-devices-tailscale0.device"];
        };
      }

      {
        what = "0mqr.lorenz.hs.leutgeb.xyz:/mnt/lorenz-sync";
        where = "/mnt/lorenz-sync";
        type = "nfs";
        wantedBy = ["remote-fs.target"];
        mountConfig.Options = "ro,noatime,hard,intr,fsc,noexec,nosuid,nodev";
        unitConfig = {
          After = ["rpcbind.target" "network.target" "sys-subsystem-net-devices-tailscale0.device"];
          BindsTo = ["sys-subsystem-net-devices-tailscale0.device"];
        };
      }
    ];
    automounts = [
      {
        inherit where;
        wantedBy = ["multi-user.target"];
        automountConfig.TimeoutIdleSec = "600";
      }
    ];
  };
}
