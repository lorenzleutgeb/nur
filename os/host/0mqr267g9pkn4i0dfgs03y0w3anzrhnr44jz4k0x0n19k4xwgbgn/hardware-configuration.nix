{ config, lib, pkgs, ... }:

{
  /* imports =
      [ (modulesPath + "/installer/scan/not-detected.nix")
      ];
  */

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "ehci_pci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "sr_mod"
  ];
  boot.kernelPackages = with pkgs; linuxPackages_5_10;
  boot.kernelModules = [ "kvm-intel" "v4l2loopback" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

  boot.extraModprobeConfig = ''
    options v4l2loopback exclusive_caps=1 video_nr=10,11 card_label="v4l2l 0","v4l2l 1"
  '';

  #boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/af3f86f8-5ca5-404e-800f-cbb4e72b953b";
    fsType = "btrfs";
    options = [ "subvol=root" ];
  };

  boot.initrd.luks.devices."root".device =
    "/dev/disk/by-uuid/75533fca-c17b-4b54-b67d-e24053b1dbe2";

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/af3f86f8-5ca5-404e-800f-cbb4e72b953b";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/af3f86f8-5ca5-404e-800f-cbb4e72b953b";
    fsType = "btrfs";
    options = [ "subvol=home" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/BC6E-4BA0";
    fsType = "vfat";
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
  hardware.video.hidpi.enable = lib.mkDefault true;

  #networking.interfaces.wlp0s20f3.useDHCP = true;
  #networking.hostName = "lorenz.leutgeb.sclable.com";

  environment.systemPackages = with pkgs; [ intel-gpu-tools libva-utils ];

  sound.enable = true;
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ vaapiIntel intel-media-driver ];
    };
  };
}
