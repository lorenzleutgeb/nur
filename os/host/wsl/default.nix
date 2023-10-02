{
  config,
  lib,
  pkgs,
  ...
}:
with builtins; let
  name = "Lorenz Leutgeb";
  username = "lorenz";
in {
  imports = [
    ../../mixin/mkcert
    ../../mixin/nix.nix
    ../../mixin/sops.nix
    ../../mixin/ssh.nix
    #../../mixin/tailscale.nix
    ../../mixin/mpi-klsb.nix
    ../../mixin/dns.nix
  ];

  wsl = {
    enable = true;
    nativeSystemd = true;
    wslConf = {
      user.default = username;
      network = {
        generateHosts = false;
        generateResolvConf = false;
      };
    };
    defaultUser = username;
    startMenuLaunchers = false;
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

    variables = {};
  };

  services = {
    cron.enable = true;
    #journald.extraConfig = "ReadKMsg=no";
    openssh = {
      enable = true;
      settings.X11Forwarding = true;
    };
    kubo.enable = false;
    pcscd.enable = true;
    printing.enable = false;
    resolved.enable = true;
  };

  # users.users.unifi.group = "unifi";
  # users.groups.unifi = { };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    createHome = true;
    home = "/home/${username}";
    description = name;
    extraGroups = ["disk" "docker" "plugdev" "networkmanager" "video" "wheel"];
    uid = 1000;
    shell = pkgs.zsh;
  };

  system.stateVersion = "20.03";

  nixpkgs.hostPlatform = "x86_64-linux";

  nix.settings.substituters = ["https://0mqr.fluffy-ordinal.ts.net/cache/?trusted=true"];

  networking = {
    firewall.enable = false;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    hostName = "wsl";
    nameservers = [];
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
      sansSerif = ["Fira Sans" "DejaVu Sans"];
      monospace = ["Fira Mono" "DejaVu Sans Mono"];
    };
  };

  sops = {
    age.sshKeyPaths =
      map (x: x.path)
      (filter (x: x.type == "ed25519") config.services.openssh.hostKeys);
    secrets."ssh/key" = {sopsFile = ./sops/ssh.yaml;};
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
    /*
    network = {
      enable = true;
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
