{
  config,
  lib,
  pkgs,
  ...
}: let
  disk = uuid: "/dev/disk/by-uuid/" + uuid;
in {
  imports = [../../mixin/intel-graphics.nix];

  fileSystems =
    (builtins.listToAttrs (map
      ({
        subvol,
        mountpoint ? "/${subvol}",
      }: {
        name = mountpoint;
        value = {
          device = disk "af3f86f8-5ca5-404e-800f-cbb4e72b953b";
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
        device = disk "BC6E-4BA0";
        fsType = "vfat";
      };
    };

  swapDevices = [
    {
      label = "swap";
      encrypted = {
        enable = true;
        blkDev = disk "c31b8709-e052-4688-9fea-056be16f857f";
        label = "swap";
        #keyFile = "/dev/sda2";
      };
    }
  ];

  # TODO
  #boot.resumeDevice = "/dev/mapper/swap";

  boot.initrd = {
    systemd = {
      enable = true;
      emergencyAccess = true;
      network = config.systemd.network;
    };
    luks.devices = {
      "root" = {
        device = disk "75533fca-c17b-4b54-b67d-e24053b1dbe2";
        #keyFile = "/dev/sda2";
        #keyFileSize = 4096;
        #keyFileTimeout = 5;
      };
      #"swap" = {
      #device = disk "c31b8709-e052-4688-9fea-056be16f857f";
      #keyFile = "/dev/sda2";
      #keyFileSize = 4096;
      #keyFileTimeout = 5;
      #};
    };
  };

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
