{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
      <nixos-hardware/lenovo/thinkpad>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/364ac200-840a-447e-bbfe-0874ffa2a278";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/6934bdff-4578-4797-b9ef-9c9e926d55e0";

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/364ac200-840a-447e-bbfe-0874ffa2a278";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  fileSystems."/var/lib/docker" =
    { device = "/dev/disk/by-uuid/364ac200-840a-447e-bbfe-0874ffa2a278";
      fsType = "btrfs";
      options = [ "subvol=docker" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/364ac200-840a-447e-bbfe-0874ffa2a278";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/BAAE-C286";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/d8973b77-eba7-4eaa-8f51-3c84818516d7";
        encrypted = {
          enable = true;
          keyFile = "/mnt-root/root/swap.key";
          label = "swap";
          blkDev = "/dev/disk/by-uuid/5d13d15c-be8e-4c04-8a59-6f1df13e97ad";
        };
      }
    ];

  # See https://wiki.archlinux.org/index.php/Suspend_and_hibernate#Hibernation
  # Docs ask to also set `resume_offset` via `boot.kernelParams` but I believe
  # this is only required for swap files.
  boot.resumeDevice = "/dev/disk/by-uuid/d8973b77-eba7-4eaa-8f51-3c84818516d7";

  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  networking.interfaces.wlp0s20f3.useDHCP = true;
  networking.hostName = "lorenz.leutgeb.sclable.com";
}
