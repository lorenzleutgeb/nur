{ config, lib, pkgs, ... }:

{
  imports = [ ../../hardware/intel-graphics.nix ];

  boot = {
    initrd = {
      # TODO: Try booting without default modules.
      #includeDefaultModules = false;
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "ehci_pci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "sr_mod"
      ];
      luks.devices."root".device =
        "/dev/disk/by-uuid/75533fca-c17b-4b54-b67d-e24053b1dbe2";
    };
    kernelModules = [
      "kvm-intel" # https://wiki.archlinux.org/index.php/KVM@
      "v4l2loopback"

      "vfio"
      "vfio_iommu_type1"
      "vfio_pci"
      "vfio_virqfd"
    ];
    kernelPackages = pkgs.linuxPackages_5_10;
    kernelParams = [ "intel_iommu=on" "mitigations=off" ];

    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

    # Add two v4l devices "v4l-0" and "v4l-1" that map to /dev/video1{0,1}.
    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 video_nr=10,11 card_label=v4l-0,v4l-1
    '';
  };

  fileSystems = (builtins.listToAttrs (map
    ({ subvol, mountpoint ? "/${subvol}" }: {
      name = mountpoint;
      value = {
        device = "/dev/disk/by-uuid/af3f86f8-5ca5-404e-800f-cbb4e72b953b";
        fsType = "btrfs";
        options =
          [ "compress=zstd" "discard=async" "noatime" "subvol=${subvol}" ];
      };
    }) [
      {
        mountpoint = "/";
        subvol = "root";
      }
      { subvol = "home"; }
      { subvol = "nix"; }
    ])) // {
      "/boot" = {
        device = "/dev/disk/by-uuid/BC6E-4BA0";
        fsType = "vfat";
      };
    };
  };

  /* No swap for now, will fix later.

     swapDevices =
       [ { device = "/dev/disk/by-uuid/1db3ad88-94b8-4e08-826b-e8b3b22ab937"; }
         { device = "/dev/disk/by-uuid/eaaf3c94-180e-4534-947b-7bc1c4b7a24c"; }
       ];

     swapDevices = [{
       device = "/dev/disk/by-uuid/d8973b77-eba7-4eaa-8f51-3c84818516d7";
       encrypted = {
         enable = true;
         keyFile = "/mnt-root/root/swap.key";
         label = "swap";
         blkDev = "/dev/disk/by-uuid/5d13d15c-be8e-4c04-8a59-6f1df13e97ad";
       };
     }];
  */

  # See https://wiki.archlinux.org/index.php/Suspend_and_hibernate#Hibernation
  # Docs ask to also set `resume_offset` via `boot.kernelParams` but I believe
  # this is only required for swap files.
  # boot.resumeDevice = "/dev/mapper/swap";

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  # high-resolution display
  hardware = {
    video.hidpi.enable = lib.mkDefault true;
    opengl.enable = true;
    bluetooth.enable = true;
  };

  environment.systemPackages = with pkgs; [ v4l-utils ];

  virtualisation.kvmgt = {
    enable = false;
    device = "0000:00:02.0";
    vgpus = {
      "i915-GVTg_V5_4" = {
        # Memory: 64MB to 384MB
        # Resolution: up to 1024x768
        uuid = [ ];
      };
      "i915-GVTg_V5_8" = {
        # Memory: 128MB to 512MB
        # Resolution: up to 1920x1200
        uuid = [ "22f62990-85c9-11eb-8dcd-0242ac130003" ];
      };
    };
  };
}
