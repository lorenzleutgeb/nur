{ config, lib, pkgs, ... }:

with builtins;

let
  name = "Lorenz Leutgeb";
  username = "lorenz";
  nextDns = rec {
    id = "9bd4a2";
    hostname = "${id}.dns.nextdns.io";
  };
  dns = (builtins.map (ip: "${ip}#${nextDns.hostname}") [
    "45.90.28.0"
    "2a07:a8c0::"
    "45.90.30.0"
    "2a07:a8c1::"
  ]) ++ [ "1.1.1.1#one.one.one.one" ];
in {
  imports = [
    ../../module/mkcert
    ../../module/nix.nix
    ../../module/sops.nix
    ../../module/tailscale.nix
    ../../module/mpi-klsb.nix
  ];

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
    dconf.enable = true;
    zsh.enable = true;
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

    variables = { };
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

  fonts.fontconfig = {
    allowBitmaps = false;
    defaultFonts = {
      sansSerif = [ "Fira Sans" "DejaVu Sans" ];
      monospace = [ "Fira Mono" "DejaVu Sans Mono" ];
    };
  };

  sops = {
    age.sshKeyPaths = map (x: x.path)
      (filter (x: x.type == "ed25519") config.services.openssh.hostKeys);
    secrets."ssh/key" = { sopsFile = ./sops/ssh.yaml; };
  };

  systemd = {
    timers."hwclock" = {
      enable = true;
      timerConfig = {
        OnStartupSec = "1s";
        OnUnitActiveSec = "1m";
      };
    };
    services."hwclock" = {
      script = "hwclock --hctosys";
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };
    services.systemd-resolved.enable = true;
    /* network = {
             networks."eth0" = {
               enable = true;
               name = "eth0";
               dns = dns;
               extraConfig = ''
       	  DNSOverTLS=yes
       	  DNSSEC=yes
       	'';
               DHCP = "yes";
               #address = [ "172.24.160.2" ];
               #gateway = [ "172.24.160.1" ];
               dhcpV4Config = {
                 UseDNS = false;
                 UseRoutes = true;
                 UseHostname = false;
                 UseDomains = true;
               };
             };
           };
    */
  };
}
