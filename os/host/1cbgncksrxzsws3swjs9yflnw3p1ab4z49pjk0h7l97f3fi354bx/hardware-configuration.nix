{ config, lib, pkgs, ... }:

{
  # TODO: Try booting without default modules.
  #boot.initrd.includeDefaultModules = false;
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelPackages = with pkgs; linuxPackages_5_10;
  boot.kernelModules = [ "kvm-intel" "wl" ];
  boot.extraModulePackages = [ boot.kernelPackages.broadcom_sta ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/bf7d978b-0989-40a7-a93e-991b55626ebb";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/9bb6dfda-bdbf-416f-b99c-d23694cd9651";

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/bf7d978b-0989-40a7-a93e-991b55626ebb";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/bf7d978b-0989-40a7-a93e-991b55626ebb";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/3A1A-7D62";
      fsType = "vfat";
    };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;

  environment.systemPackages = with pkgs; [
    intel-gpu-tools
    libva-utils
    #vdpauinfo
  ];

  sound.enable = true;
  hardware = {
    opengl = {
      # NOTE: Couldn't get VDPAU via VAAPI to work. Probably don't need it.
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        #libvdpau
        #libvdpau-va-gl
      ];
    };
  };
}
