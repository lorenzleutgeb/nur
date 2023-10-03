{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../mixin/dns.nix
    ../../mixin/fonts.nix
    ../../mixin/kmscon.nix
    ../../mixin/lorenz.nix
    ../../mixin/mkcert
    ../../mixin/nix.nix
    ../../mixin/progressive.nix
    ../../mixin/sops.nix
    ../../mixin/ssh.nix
    ../../mixin/tailscale.nix
    ./hardware-configuration.nix
    ./bluetooth.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    binfmt.emulatedSystems = ["aarch64-linux"];

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 16;
      };
      efi.canTouchEfiVariables = true;
    };

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
      luks.devices."root".device = "/dev/disk/by-uuid/75533fca-c17b-4b54-b67d-e24053b1dbe2";
    };

    kernel.sysctl = {
      "fs.inotify.max_user_watches" = 65536;
    };

    kernelModules = [
      "kvm-intel" # https://wiki.archlinux.org/index.php/KVM@
      # "v4l2loopback" for screen recording

      "vfio"
      "vfio_iommu_type1"
      "vfio_pci"
      "vfio_virqfd"
    ];
    tmp.useTmpfs = true;
  };

  systemd.network = let
    intel = "enp110s0";
    #broadcom = "enp111s0f1";
    device = intel;
    matchConfig.Name = device;
  in {
    enable = true;
    links.${device} = {
      inherit matchConfig;
      linkConfig.WakeOnLan = "magic";
    };
    networks.${device} = {
      inherit matchConfig;
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      dns = config.services.resolved.fallbackDns;
      dhcpV4Config = {
        UseDNS = false;
        UseRoutes = true;
      };
    };
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
    hostName = "0mqr267g9pkn4i0dfgs03y0w3anzrhnr44jz4k0x0n19k4xwgbgn";

    firewall = {
      allowedTCPPorts = [
        # 8443 # unifi
        5900 # wayvnc
        8384 # syncthing
      ];
      allowedUDPPorts = [
        # 9 # Debugging Wake-on-LAN
      ];
    };
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

  programs = {
    adb.enable = true;
    dconf.enable = true;
    java = {
      enable = true;
      binfmt = true;
    };
    mosh.enable = true;
    sedutil.enable = true;
    zsh.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      coreutils-full
      dmidecode
      exfat
      libvirt
      lshw
      lsof
      nfs-utils
      utillinux
      which
      tpm2-tools
      config.boot.kernelPackages.perf
    ];
    sessionVariables.LIBVA_DRIVER_NAME = "iHD";
  };

  services = {
    accounts-daemon.enable = true;
    beesd.filesystems."root" = {
      spec = "/";
      hashTableSizeMB = 2048;
      extraOptions = ["--thread-count" "4"];
    };
    blueman.enable = false;
    cron.enable = true;
    flatpak.enable = true;
    fwupd.enable = true;
    #journald.extraConfig = "ReadKMsg=no";
    openssh = {
      enable = true;
      settings.X11Forwarding = true;
      hostKeys = [
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };
    kubo.enable = false;
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
    };

    sourcehut = {
      services = ["man" "meta" "git" "builds" "hub" "todo" "lists"];
    };

    udev = {
      packages = [pkgs.yubikey-personalization];
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
        #ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c068", RUN+="${pkgs.bash}/bin/bash -c 'echo $env{DEVPATH} >> /home/lorenz/log'"

        # BeagleBone Black gets /dev/ttybbb
        KERNEL=="ttyACM[0-9]*", SUBSYSTEM=="tty", ATTRS{idVendor}=="1d6b", ATTRS{idProduct}=="0104", SYMLINK="ttybbb"
      '';
    };

    unifi = {
      enable = false;
      unifiPackage = pkgs.unifi;
      openFirewall = false;
    };

    logind.extraConfig = ''
      RuntimeDirectorySize=24G
    '';

    resolved.enable = true;
  };

  users.users.lorenz.extraGroups = [
    "adbusers"
    "docker"
    "libvirtd"
    "mkcert"
    "networkmanager"
    "vboxusers"
  ];

  system.stateVersion = "20.03";

  nixpkgs.hostPlatform = "x86_64-linux";

  security = {
    sudo.wheelNeedsPassword = false;
    pam = {
      u2f = {
        enable = true;
        cue = true;
      };
      services = {"swaylock" = {};};
    };
    rtkit.enable = true;
    tpm2 = {
      enable = true;
      abrmd.enable = true;
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = false;
    };
    virtualbox.host.enable = false;
    libvirtd = {
      enable = true;
      qemu.package = pkgs.qemu_kvm;
    };
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
    };
  };

  sops = {
    age.sshKeyPaths = map (x: x.path) config.services.openssh.hostKeys;
    secrets = {
      "ssh/key".sopsFile = ./sops/ssh.yaml;
    };
  };
}
