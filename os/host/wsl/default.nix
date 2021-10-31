{ hardware, lib, pkgs, ... }:

with builtins;

let
  name = "Lorenz Leutgeb";
  username = "lorenz";
in {
  enable4k = true;

  imports = [ ./mkcert.nix ./wsl.nix ];

  # Use the systemd-boot EFI boot loader.
  /* boot = {
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
  */

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
    # Configuration of DHCP per-interface was moved to hardware-configuration.nix
    useDHCP = false;
    networkmanager = {
      enable = true;
      #dns = "dnsmasq";
    };
    resolvconf.useLocalResolver = true;
    hostName = "wsl";
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
    #adb.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      coreutils-full
      #dmidecode
      #exfat
      #exfat-utils
      lshw
      lsof
      nixFlakes
      nfs-utils
      utillinux
      which
    ];
    sessionVariables.LIBVA_DRIVER_NAME = "iHD";
  };

  sound.enable = true;

  services = {
    blueman.enable = false;
    cron.enable = true;
    flatpak.enable = true;
    fwupd.enable = true;
    #journald.extraConfig = "ReadKMsg=no";
    pcscd.enable = true;
    #printing.enable = true;
    #tailscale.enable = true;

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
      media-session.enable = true;
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
      '';
    };

    /* logind.extraConfig = ''
         RuntimeDirectorySize=24G
       '';
    */
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
    virtualbox.host.enable = false;
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

  # X11 Forwarding
  services.openssh = {
    enable = true;
    forwardX11 = true;
  };

  programs.ssh = {
    forwardX11 = true;
    setXAuthLocation = true;
  };
}

