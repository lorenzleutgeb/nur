{...}: {
  services = {
    rpcbind.enable = true;
    nfs.server = {
      enable = true;
      hostName = "0mqr";

      # <https://man7.org/linux/man-pages/man5/exports.5.html>
      exports = ''
        /mnt/share 100.85.40.10(fsid=1,rw,insecure,no_root_squash,no_subtree_check)
        /mnt/lorenz-sync 100.85.40.10(fsid=2,ro,insecure,no_root_squash,no_subtree_check)
      '';
    };
  };

  fileSystems = {
    "/mnt/share" = {
      device = "/dev/disk/by-uuid/af3f86f8-5ca5-404e-800f-cbb4e72b953b";
      fsType = "btrfs";
      options = ["compress=zstd" "discard=async" "noatime" "subvol=share"];
    };
    "/mnt/lorenz-sync" = {
      device = "/home/lorenz/sync";
      options = ["bind" "ro" "uid=993" "gid=992" "noexec" "noatime" "nosuid"];
      depends = ["/home"];
    };
  };

  systemd = {
    services."nfs-server" = {
      after = ["tailscaled.service"];
      bindsTo = ["tailscaled.service"];
    };
    /*
    mounts = [
      {
        what = "/home/lorenz/sync";
        where = "/mnt/lorenz";
        mountConfig.Options = ["bind" "ro" "uid=993" "gid=992" "noexec" "noatime" "nosuid"];
        unitConfig = {
          After = ["home.mount"];
          BindsTo = ["home.mount"];
        };
      }
    ];
    */
  };
}
