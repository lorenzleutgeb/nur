{ config, lib, pkgs, ... }:

{
  imports = [ ../../hardware/intel-graphics.nix ];

  boot = {
    # TODO: Try booting without default modules.
    #initrd.includeDefaultModules = false;
    initrd = {
      availableKernelModules =
        [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];

      luks.devices."root".device =
        "/dev/disk/by-uuid/6934bdff-4578-4797-b9ef-9c9e926d55e0";
    };
    kernelPackages = pkgs.linuxPackages_5_10;
    kernelModules = [ "kvm-intel" "e1000e" "v4l2loopback" ];
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

    # Add two v4l devices "v4l-0" and "v4l-1" that map to /dev/video1{0,1}.
    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 video_nr=10,11 card_label=v4l2l-0,v4l2l-1
    '';

    # See https://wiki.archlinux.org/index.php/Suspend_and_hibernate#Hibernation
    # Docs ask to also set `resume_offset` via `boot.kernelParams` but I believe
    # this is only required for swap files.
    resumeDevice = "/dev/mapper/swap";
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/364ac200-840a-447e-bbfe-0874ffa2a278";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/364ac200-840a-447e-bbfe-0874ffa2a278";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

    "/var/lib/docker" = {
      device = "/dev/disk/by-uuid/364ac200-840a-447e-bbfe-0874ffa2a278";
      fsType = "btrfs";
      options = [ "subvol=docker" ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/364ac200-840a-447e-bbfe-0874ffa2a278";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/BAAE-C286";
      fsType = "vfat";
    };
  };

  swapDevices = [{
    device = "/dev/disk/by-uuid/d8973b77-eba7-4eaa-8f51-3c84818516d7";
    encrypted = {
      enable = true;
      keyFile = "/mnt-root/root/swap.key";
      label = "swap";
      blkDev = "/dev/disk/by-uuid/5d13d15c-be8e-4c04-8a59-6f1df13e97ad";
    };
  }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;

  environment.systemPackages = with pkgs; [ v4l-utils ];

  sound.enable = true;
}
