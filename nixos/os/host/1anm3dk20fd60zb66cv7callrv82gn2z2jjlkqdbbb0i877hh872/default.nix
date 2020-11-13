{ hardware, lib, pkgs, ... }:

with builtins;

let
  name = "Lorenz Leutgeb";
  username = "lorenz";
in {
  imports = [ ./hardware-configuration.nix "${hardware}/lenovo/thinkpad" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 16;
  boot.loader.efi.canTouchEfiVariables = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.networkmanager.enable = true;
  # Configuration of DHCP per-interface was moved to hardware-configuration.nix

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

    # Enable the OpenSSH daemon.
    openssh.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # Enable CUPS to print documents.
    printing.enable = true;

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
      RuntimeDirectorySize=8G
    '';

    udev = {
      packages = [ pkgs.yubikey-personalization ];
      # See https://github.com/zsa/wally/wiki/Linux-install#2-create-a-udev-rule-file
      extraRules = ''
        ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
        ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
        KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"
      '';
    };
    pcscd.enable = true;

    flatpak.enable = true;

    kmonad = {
      enable = true;
      extraConfig = builtins.readFile ./kmonad.kbd;
    };

  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    createHome = true;
    home = "/home/${username}";
    description = name;
    extraGroups = [ "audio" "disk" "docker" "networkmanager" "video" "wheel" ];
    uid = 1000;
    shell = pkgs.zsh;
  };

  home-manager.users.${username} = import ./home-manager;

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03";

  programs.ssh.startAgent = true;

  security.sudo.wheelNeedsPassword = false;

  programs.zsh.enable = true;

  # If adding a font here does not work, try running
  # fc-cache -f -v
  fonts.fonts = with pkgs; [
    dejavu_fonts
    fira-code
    fira-code-symbols
    noto-fonts
  ];

  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = true;

  nixpkgs.config.allowUnfree = true;

  # Hacks in /etc/hosts for projects.
  networking.extraHosts = ''
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

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  #virtualisation.virtualbox.host.enable = true;
  #users.extraGroups.vboxusers.members = [ "lorenz" ];
}

