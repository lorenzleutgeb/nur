{
  config,
  lib,
  pkgs,
  ...
}: {
  boot.initrd.availableKernelModules = [
    "ata_generic"
    "ehci_pci"
    "ahci"
    "xhci_pci"
    "firewire_ohci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  # Copied over from configuration.nix
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/eccddb77-effe-4498-884a-32fcb9e5638e";
    fsType = "btrfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0EE6-7958";
    fsType = "vfat";
  };

  swapDevices = [{device = "/dev/disk/by-uuid/1db3ad88-94b8-4e08-826b-e8b3b22ab937";}];

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/0614c2cb-362d-4746-a8fd-901df900950a";
    fsType = "btrfs";
    options = ["subvol=home"];
  };

  fileSystems."/srv-backup" = {
    device = "/dev/disk/by-uuid/0614c2cb-362d-4746-a8fd-901df900950a";
    fsType = "btrfs";
    options = ["subvol=srv" "ro"];
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
