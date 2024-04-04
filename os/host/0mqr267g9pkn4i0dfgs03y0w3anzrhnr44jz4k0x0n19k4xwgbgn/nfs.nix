{...}: {
  services = {
    rpcbind.enable = true;
    nfs.server = {
      enable = true;
      hostName = "0mqr.lorenz.hs.leutgeb.xyz";

      # <https://man7.org/linux/man-pages/man5/exports.5.html>
      exports = ''
        /mnt/share nc.lorenz.hs.leutgeb.xyz(fsid=1,rw,insecure,no_root_squash,no_subtree_check)
      '';
    };
  };

  fileSystems."/mnt/share" = {
    device = "/dev/disk/by-uuid/af3f86f8-5ca5-404e-800f-cbb4e72b953b";
    fsType = "btrfs";
    options = ["compress=zstd" "discard=async" "noatime" "subvol=share"];
  };
}
