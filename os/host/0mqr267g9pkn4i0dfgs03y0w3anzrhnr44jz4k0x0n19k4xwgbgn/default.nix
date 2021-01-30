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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    binutils
    coreutils
    elfutils
    exfat
    fuse
    gcc
    gnumake
    lsof
    nixFlakes
    utillinux
    vim
    wirelesstools
    wget
    which
    xorg.xkill
    zip
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };
  programs = { adb.enable = true; };

  services = {
    cron.enable = true;
    # TODO: Remove?
    neo4j.enable = false;
    blueman.enable = false;

    fwupd.enable = true;

    tailscale.enable = true;

    # Enable the OpenSSH daemon.
    openssh.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # Enable CUPS to print documents.
    printing.enable = true;

    journald.extraConfig = "ReadKMsg=no";

    # Enable the X11 windowing system.
    xserver = {
      autorun = true;
      enable = true;
      layout = "us";
      xkbOptions = "eurosign:e";
      libinput.enable = true;
      displayManager.defaultSession = "none+i3";
      desktopManager = { xterm.enable = false; };
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [ dmenu i3status i3lock ];
      };
    };

    # Enable the KDE Desktop Environment.
    # services.xserver.displayManager.sddm.enable = true;
    # services.xserver.desktopManager.plasma5.enable = true;

    logind.extraConfig = ''
      RuntimeDirectorySize=24G
    '';

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
      '';
    };
    pcscd.enable = true;

    flatpak.enable = true;
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
      "plugdev"
      "networkmanager"
      "video"
      "wheel"
    ];
    uid = 1000;
    shell = pkgs.zsh;
  };
  users.extraGroups.vboxusers.members = [ "lorenz" ];

  home-manager.users.${username} = import ./home-manager;

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03";

  security = {
    sudo.wheelNeedsPassword = false;
    pam.u2f = {
      enable = true;
      cue = true;
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
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    maxJobs = lib.mkDefault 8;
  };
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}

