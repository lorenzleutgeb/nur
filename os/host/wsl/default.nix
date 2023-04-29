{ config, lib, pkgs, ... }:

with builtins;

let
  name = "Lorenz Leutgeb";
  username = "lorenz";
in {
  enable4k = true;

  imports = [ ../../module/tailscale.nix ];

  wsl = {
    enable = true;
    nativeSystemd = true;
    wslConf = {
      user.default = "lorenz";
      network = {
        generateHosts = false;
        generateResolvConf = false;
      };
    };
    defaultUser = "lorenz";
    startMenuLaunchers = false;
    #docker-desktop.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";

  programs = {
    sedutil.enable = true;
    nix-ld.enable = true;
    dconf.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      coreutils-full
      exfat
      lshw
      lsof
      nfs-utils
      utillinux
      which
      wget
      config.boot.kernelPackages.perf
    ];
  };

  services = {
    cron.enable = true;
    #journald.extraConfig = "ReadKMsg=no";
    openssh = {
      enable = true;
      forwardX11 = true;
    };
    kubo.enable = false;
    pcscd.enable = true;
    printing.enable = false;
  };

  # users.users.unifi.group = "unifi";
  # users.groups.unifi = { };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    createHome = true;
    home = "/home/${username}";
    description = name;
    extraGroups =
      [ "disk" "docker" "plugdev" "networkmanager" "video" "wheel" ];
    uid = 1000;
    shell = pkgs.zsh;
  };

  home-manager.users.${username}.imports = [
    ../../../hm/profiles/latex.nix
    ../../../hm/profiles/mpi-klsb.nix
    ../../../hm/profiles/terminal.nix
    ../../../hm/profiles/spass.nix
    ../../../hm/programs/vscode.nix
    ../../../hm/profiles/wsl.nix
  ];

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03";

  networking = {
    firewall.enable = false;
    networkmanager.enable = true;
    hostName = "wsl";
  };

  security = {
    sudo.wheelNeedsPassword = false;
    pam = {
      u2f = {
        enable = false;
        cue = true;
      };
    };
    rtkit.enable = true;
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

  nixpkgs.config = { allowUnfree = true; };

  fonts.fontconfig = {
    allowBitmaps = false;
    defaultFonts = {
      sansSerif = [ "Fira Sans" "DejaVu Sans" ];
      monospace = [ "Fira Mono" "DejaVu Sans Mono" ];
    };
  };
}

