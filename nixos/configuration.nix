{ config, lib, pkgs, ... }:

{
  imports =
    [  ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.networkmanager.enable = true;
  # Configuration of DHCP per-interface was moved to hardware-configuration.nix

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

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

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    autorun = true;
    enable = true;
    layout = "us";
    xkbOptions = "eurosign:e";
    libinput.enable = true;
    displayManager.defaultSession = "none+i3";
    desktopManager = {
      xterm.enable = false;
    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
     ];
    };
  };

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lorenz = {
    isNormalUser = true;
    createHome = true;
    home = "/home/lorenz";
    description = "Lorenz Leutgeb";
    extraGroups = ["audio" "docker" "networkmanager" "wheel"];
    uid = 1000;
    shell = pkgs.zsh;
  };

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03";

  programs.ssh.startAgent = true;

  security.sudo.wheelNeedsPassword = false;

  programs.zsh.enable = true;

  fonts.fonts = with pkgs; [
    fira-code
    fira-code-symbols
  ];

  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = true;

  services.logind.extraConfig = ''
    RuntimeDirectorySize=8G
  '';

  nixpkgs.config.allowUnfree = true;

  # Hacks in /etc/hosts for projects.
  networking.extraHosts = ''
    172.16.239.10 postgres.x.sclable.io
    172.16.239.11 keycloak.x.sclable.io
    172.16.239.12 wildfly.x.sclable.io
    172.16.239.13 gateway.x.sclable.io
  '';

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes";
  };
}

