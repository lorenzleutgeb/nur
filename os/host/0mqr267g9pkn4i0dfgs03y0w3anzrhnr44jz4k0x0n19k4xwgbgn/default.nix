{
  config,
  lib,
  pkgs,
  ...
}:
with builtins; let
  name = "Lorenz Leutgeb";
  username = "lorenz";
  tunnelId = "2e5b6e6f-6236-4e44-ac82-5a10fdba61ac";
in {
  #enable4k = true;

  imports = [
    ./hardware-configuration.nix
    ../../mixin/kmscon.nix
    ../../mixin/mkcert
    ../../mixin/nix.nix
    ../../mixin/sops.nix
    ../../mixin/ssh.nix
    ../../mixin/tailscale.nix
    ../../mixin/dns.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    tmp.useTmpfs = true;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 16;
      };
      efi.canTouchEfiVariables = true;
    };
    kernel.sysctl = {
      "fs.inotify.max_user_watches" = 65536;
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };
  };

  systemd.network = let
    mkConfig = name: {
      matchConfig.Name = name;
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
  in {
    enable = true;
    networks = {
      "enp111s0f1" = mkConfig "enp111s0f1";
      #"enp110s0" = mkConfig "enp110s0";
    };
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
    # Configuration of DHCP per-interface was moved to hardware-configuration.nix
    useDHCP = false;
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
      # Strict reverse path filtering breaks Tailscale exit node use and
      # some subnet routing setups.
      checkReversePath = "loose";
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
    sedutil.enable = true;
    adb.enable = true;
    dconf.enable = true;
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

  environment.etc = {
    "wireplumber/bluetooth.lua.d/50-bluez-config.lua".text = ''
      bluez_monitor.properties = {
      	["bluez5.enable-sbc-xq"] = true,
      	["bluez5.enable-msbc"] = true,
      	["bluez5.enable-hw-volume"] = true,
      	["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
    '';
  };

  services = {
    accounts-daemon.enable = true;
    beesd.filesystems."root" = {
      spec = "/";
      hashTableSizeMB = 2048;
      extraOptions = ["--thread-count" "4"];
    };
    blueman.enable = false;
    cloudflared = {
      enable = false;
      tunnels."${tunnelId}" = {
        credentialsFile =
          config.sops.secrets."cloudflared/tunnel/${tunnelId}.json".path;
        default = "http_status:404";
        ingress."0mqr.falsum.org" = "ssh://localhost:22";
      };
    };
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

  # users.users.unifi.group = "unifi";
  # users.groups.unifi = { };

  users.users.tss.group = "tss";
  users.groups.tss = {};

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
      "mkcert"
      "plugdev"
      "networkmanager"
      "vboxusers"
      "video"
      "wheel"
    ];
    uid = 1000;
    shell = pkgs.zsh;
  };

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

  fonts.fontconfig = {
    allowBitmaps = false;
    defaultFonts = {
      sansSerif = ["Fira Sans" "DejaVu Sans"];
      monospace = ["Fira Mono" "DejaVu Sans Mono"];
    };
  };

  sops = {
    age.sshKeyPaths = map (x: x.path) config.services.openssh.hostKeys;
    secrets = {
      "ssh/key".sopsFile = ./sops/ssh.yaml;
      "cloudflared/tunnel/${tunnelId}.json" = {
        sopsFile = ./sops/tunnel.bin;
        format = "binary";
        owner = config.services.cloudflared.user;
        group = config.services.cloudflared.group;
      };
    };
  };
}
