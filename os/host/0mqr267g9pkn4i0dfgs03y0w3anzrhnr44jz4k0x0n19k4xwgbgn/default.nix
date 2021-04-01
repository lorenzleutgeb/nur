{ hardware, lib, pkgs, ... }:

with builtins;

let
  name = "Lorenz Leutgeb";
  username = "lorenz";
in {
  imports = [ ./hardware-configuration.nix ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    tmpOnTmpfs = true;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 16;
      };
      efi.canTouchEfiVariables = true;
    };
    kernel.sysctl = { "fs.inotify.max_user_watches" = 65536; };
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
    # Configuration of DHCP per-interface was moved to hardware-configuration.nix
    useDHCP = false;
    networkmanager.enable = true;
    hostName = "0mqr267g9pkn4i0dfgs03y0w3anzrhnr44jz4k0x0n19k4xwgbgn";

    # Hacks in /etc/hosts for projects.
    extraHosts = ''
      172.16.239.10 postgres.x.sclable.io
      172.16.239.11 keycloak.x.sclable.io
      172.16.239.12 wildfly.x.sclable.io
      172.16.239.13 gateway.x.sclable.io
      172.16.239.15 zookeeper.x.sclable.io
      172.16.239.16 kafka.x.sclable.io
      172.16.239.17 schemaregistry.x.sclable.io
      172.16.239.18 nuxeo.x.sclable.io
      172.16.239.19 openldap.x.sclable.io
      172.16.239.20 phpldapadmin.x.sclable.io
    '';
  };

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Set your time zone.
  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";

  environment = {
    systemPackages = with pkgs; [
      coreutils-full
      dmidecode
      exfat
      exfat-utils
      lshw
      lsof
      nixFlakes
      utillinux
      which
      tpm2-tools
    ];
    sessionVariables.LIBVA_DRIVER_NAME = "iHD";
  };

  services = {
    blueman.enable = false;
    cron.enable = true;
    flatpak.enable = true;
    fwupd.enable = true;
    #journald.extraConfig = "ReadKMsg=no";
    openssh = {
      enable = true;
      forwardX11 = true;
    };
    pcscd.enable = true;
    printing.enable = true;
    tailscale.enable = true;

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };

    udev = {
      packages = [ pkgs.yubikey-personalization ];
      extraRules = ''
        # Teensy rules for the Ergodox EZ
        # See https://github.com/zsa/wally/wiki/Linux-install#2-create-a-udev-rule-file
        ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
        ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
        KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"

        # Tobii 4C
        SUBSYSTEM=="usb", ATTRS{idVendor}=="2104", ATTRS{idProduct}=="0118", GROUP="plugdev", MODE="0666", TAG+="uaccess"

        # TODO: Find out why this does not work and re-enable.
        # Prevent Logitech G500 Laser Mouse from waking up the system
        # This is very fragile, since the physical port that the mouse is plugged into is hardcoded.
        # https://wiki.archlinux.org/index.php/udev#Waking_from_suspend_with_USB_device
        #SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c068", SYMLINK+="logitech_g500"
        #ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c068", ATTR{driver/2-13.3.2/power/wakeup}="disabled"
        #ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c068", RUN+="/bin/sh -c 'echo $env{DEVPATH} >> /home/lorenz/log'"
      '';
    };

    logind.extraConfig = ''
      RuntimeDirectorySize=24G
    '';
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    createHome = true;
    home = "/home/${username}";
    description = name;
    extraGroups = [
      "adbusers"
      "audio"
      "disk"
      "docker"
      "libvirtd"
      "plugdev"
      "networkmanager"
      "vboxusers"
      "video"
      "wheel"
    ];
    uid = 1000;
    shell = pkgs.zsh;
  };

  home-manager.users.${username} = import ./home-manager;

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03";

  security = {
    sudo.wheelNeedsPassword = false;
    pam = {
      u2f = {
        enable = true;
        cue = true;
      };
      services = { "swaylock" = { }; };
    };
    rtkit.enable = true;
    tpm2 = {
      enable = true;
      abrmd.enable = true;
    };
  };

  # If adding a font here does not work, try running
  # fc-cache -f -v
  fonts.fonts = with pkgs; [
    dejavu_fonts
    fira-code
    fira-code-symbols
    noto-fonts
  ];

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
    };
    # Waiting for https://github.com/NixOS/nixpkgs/pull/101493
    virtualbox.host.enable = true;
    libvirtd = {
      enable = true;
      qemuPackage = pkgs.qemu_kvm;
    };
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    maxJobs = lib.mkDefault 8;
  };
  nixpkgs.config = {
    allowUnfree = true;
    #allowBroken = true;
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
      gtkUsePortal = true;
    };
  };

  fonts.fontconfig = {
    allowBitmaps = false;
    defaultFonts = {
      sansSerif = [ "Fira Sans" "DejaVu Sans" ];
      monospace = [ "Fira Mono" "DejaVu Sans Mono" ];
    };
  };
}

