{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [../../mixin/intel-graphics.nix];

  fileSystems =
    (builtins.listToAttrs (map
      ({
        subvol,
        mountpoint ? "/${subvol}",
      }: {
        name = mountpoint;
        value = {
          device = "/dev/disk/by-uuid/af3f86f8-5ca5-404e-800f-cbb4e72b953b";
          fsType = "btrfs";
          options = ["compress=zstd" "discard=async" "noatime" "subvol=${subvol}"];
        };
      }) [
        {
          mountpoint = "/";
          subvol = "root";
        }
        {subvol = "home";}
        {subvol = "nix";}
      ]))
    // {
      "/boot" = {
        device = "/dev/disk/by-uuid/BC6E-4BA0";
        fsType = "vfat";
      };
    };

  swapDevices = [
    {
      label = "swap";
      encrypted = {
        enable = true;
        blkDev = "/dev/nvme0n1p2";
        label = "swap";
      };
    }
  ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  hardware = {
    opengl.enable = true;
    bluetooth.enable = true;
  };

  virtualisation.kvmgt = {
    enable = false;
    device = "0000:00:02.0";
    vgpus = {
      "i915-GVTg_V5_4" = {
        # Memory: 64MB to 384MB
        # Resolution: up to 1024x768
        uuid = [];
      };
      "i915-GVTg_V5_8" = {
        # Memory: 128MB to 512MB
        # Resolution: up to 1920x1200
        uuid = ["22f62990-85c9-11eb-8dcd-0242ac130003"];
      };
    };
  };
}
