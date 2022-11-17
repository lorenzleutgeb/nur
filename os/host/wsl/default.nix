{ config, hardware, lib, pkgs, ... }:

with builtins;

let
  name = "Lorenz Leutgeb";
  username = "lorenz";
in {
  enable4k = true;

  imports = [];

   wsl = {
    enable = true;
    nativeSystemd = true;
    wslConf = {
      automount.root = "/mnt";
      user.default = "lorenz";
    };
    defaultUser = "lorenz";
    startMenuLaunchers = true;

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";

  programs = {
    sedutil.enable = true;
    nix-ld.enable = true;
    adb.enable = true;
    dconf.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      coreutils-full
      dmidecode
      exfat
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

  environment.etc."NetworkManager/dnsmasq.d/tailscale.conf".text = ''
    server=/connected-dots.org.github.beta.tailscale.net/100.100.100.100
    server=100.100.100.100@tailscale0
  '';

  services = {
    accounts-daemon.enable = true;
    blueman.enable = false;
    cloudflared = {
      enable = false;
      config = { };
    };
    cron.enable = true;
    flatpak.enable = false;
    fwupd.enable = false;
    #journald.extraConfig = "ReadKMsg=no";
    openssh = {
      enable = true;
      forwardX11 = true;
    };
    kubo.enable = false;
    pcscd.enable = true;
    printing.enable = false;
    tailscale.enable = true;

    pipewire = {
      enable = false;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      #jack.enable = true;
      #media-session.enable = true;
      #wireplumber.enable = false;
    };

    sourcehut = {
      services = [ "man" "meta" "git" "builds" "hub" "todo" "lists" ];
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
  };

  # users.users.unifi.group = "unifi";
  # users.groups.unifi = { };

  users.users.tss.group = "tss";
  users.groups.tss = { };

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
      enableOnBoot = false;
    };
    virtualbox.host.enable = false;
    libvirtd = {
      enable = false;
      qemu.package = pkgs.qemu_kvm;
    };
  };

  nix = {
    package = pkgs.nixFlakes;
    settings = {
      substituters = [ "https://lean4.cachix.org/" ];
      trusted-public-keys =
        [ "lean4.cachix.org-1:mawtxSxcaiWE24xCXXgh3qnvlTkyU7evRRnGeAhD4Wk=" ];
    };
    extraOptions = ''
      allow-import-from-derivation = true
      experimental-features = nix-command flakes
      keep-outputs = true
    '';
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

