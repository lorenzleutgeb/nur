{ config, lib, pkgs, ... }:

{
  boot.initrd.availableKernelModules =
    [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  #boot.kernelPackages = with pkgs; linuxPackages_5_7;
  boot.kernelPackages = with pkgs; linuxPackages_5_9;
  boot.kernelModules = [ "kvm-intel" "e1000e" "v4l2loopback" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    #e1000e
    v4l2loopback
  ];

  boot.extraModprobeConfig = ''
    options v4l2loopback exclusive_caps=1 video_nr=10,11 card_label="v4l2l 0","v4l2l 1"
  '';

  #boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/364ac200-840a-447e-bbfe-0874ffa2a278";
    fsType = "btrfs";
    options = [ "subvol=root" ];
  };

  boot.initrd.luks.devices."root".device =
    "/dev/disk/by-uuid/6934bdff-4578-4797-b9ef-9c9e926d55e0";

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/364ac200-840a-447e-bbfe-0874ffa2a278";
    fsType = "btrfs";
    options = [ "subvol=home" ];
  };

  fileSystems."/var/lib/docker" = {
    device = "/dev/disk/by-uuid/364ac200-840a-447e-bbfe-0874ffa2a278";
    fsType = "btrfs";
    options = [ "subvol=docker" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/364ac200-840a-447e-bbfe-0874ffa2a278";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/BAAE-C286";
    fsType = "vfat";
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

  # See https://wiki.archlinux.org/index.php/Suspend_and_hibernate#Hibernation
  # Docs ask to also set `resume_offset` via `boot.kernelParams` but I believe
  # this is only required for swap files.
  boot.resumeDevice = "/dev/mapper/swap";

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  networking.interfaces.wlp0s20f3.useDHCP = true;
  #networking.hostName = "lorenz.leutgeb.sclable.com";

  sound.enable = true;
  hardware = {
    bluetooth.enable = true;

    pulseaudio = {
      enable = true;

      # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
      # Only the full build has Bluetooth support, so it must be selected here.
      package = pkgs.pulseaudioFull;

      extraConfig = ''
        #load-module module-alsa-sink   device=hw:0,0 channels=4
        #load-module module-alsa-source device=hw:0,6 channels=4
        .ifexists module-bluetooth-discover.so
          # https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/Modules/#module-switch-on-connect
          load-module module-switch-on-connect
        .endif
      '';

    };

    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-media-driver # only available starting nixos-19.03 or the current nixos-unstable
      ];
    };
  };

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
}
