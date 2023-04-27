{ hardware, lib, pkgs, ... }:

with builtins;

let
  name = "Lorenz Leutgeb";
  username = "lorenz";
in {
  imports = [ ./hardware-configuration.nix ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 16;
    };
    #efi.canTouchEfiVariables = true;
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
    # Configuration of DHCP per-interface was moved to hardware-configuration.nix
    useDHCP = false;
    networkmanager.enable = true;
    hostName = "0wla8w9nlc3a4w4xm1jsj3924icwyyb04dd0kkn27wgryd4ddbik";
    interfaces.eno1.useDHCP = true;

    firewall.allowedTCPPorts = [ 80 443 ];
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
  services = {
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

    logind.extraConfig = ''
      RuntimeDirectorySize=8G
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
      '';
    };

    flatpak.enable = true;

    unifi.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    createHome = true;
    home = "/home/${username}";
    description = name;
    extraGroups =
      [ "audio" "disk" "docker" "plugdev" "networkmanager" "video" "wheel" ];
    uid = 1000;
    shell = pkgs.zsh;
  };

  users.users.nginx.extraGroups = [ "acme" ];

  system.stateVersion = "20.03";

  security = {
    sudo.wheelNeedsPassword = false;
    pam.u2f = {
      enable = true;
      cue = true;
    };
    acme = {
      email = "lorenz@leutgeb.xyz";
      acceptTerms = true;
      certs = {
        "0wla8w9nlc3a4w4xm1jsj3924icwyyb04dd0kkn27wgryd4ddbik.leutgeb.xyz" = {
          email = "lorenz@leutgeb.xyz";
          dnsProvider = "cloudflare";
          credentialsFile = "/home/lorenz/.config/lego/cloudflare";
          extraDomainNames = [
            "*.0wla8w9nlc3a4w4xm1jsj3924icwyyb04dd0kkn27wgryd4ddbik.leutgeb.xyz"
          ];
        };
      };
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
    };
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    maxJobs = lib.mkDefault 8;
  };
  nixpkgs.config.allowUnfree = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}

