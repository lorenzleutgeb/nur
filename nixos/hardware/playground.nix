{ config, lib, pkgs, ... }:

{
  imports = [ ];

  boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/cfc36bff-bdb1-4e66-a690-45a7360c40a6";
      fsType = "btrfs";
      options = [ "subvol=root,nodatacow" ];
    };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/a3d2e46c-8ab4-48c8-b169-824aba778a92";

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/cfc36bff-bdb1-4e66-a690-45a7360c40a6";
      fsType = "btrfs";
      options = [ "subvol=home,nodatacow" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/cfc36bff-bdb1-4e66-a690-45a7360c40a6";
      fsType = "btrfs";
      options = [ "subvol=nix,nodatacow" ];
    };

  fileSystems."/var/lib/docker" =
    { device = "/dev/disk/by-uuid/cfc36bff-bdb1-4e66-a690-45a7360c40a6";
      fsType = "btrfs";
      options = [ "subvol=docker,nodatacow" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/DA69-A608";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/a909fa16-1691-482d-a59b-d208259249ee";
        encrypted = {
          enable = true;
          keyFile = "/mnt-root/root/swap.key";
          label = "swap";
          blkDev = "/dev/disk/by-uuid/e729c5dc-e482-4107-8985-22a7ef93fee3";
        };
      }
    ];

  # See https://wiki.archlinux.org/index.php/Suspend_and_hibernate#Hibernation
  # Docs ask to also set `resume_offset` via `boot.kernelParams` but I believe
  # this is only required for swap files.
  boot.resumeDevice = "/dev/disk/by-uuid/a909fa16-1691-482d-a59b-d208259249ee";

  nix.maxJobs = lib.mkDefault 2;
  virtualisation.virtualbox.guest.enable = true;

  networking.interfaces.enp0s3.useDHCP = true;
  networking.hostName = "playground.lorenz.leutgeb.sclable.com";
}
