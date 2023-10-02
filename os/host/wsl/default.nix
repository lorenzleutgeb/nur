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
    ../../mixin/dns.nix
    ../../mixin/fonts.nix
    ../../mixin/lorenz.nix
    ../../mixin/mkcert
    ../../mixin/mpi-klsb.nix
    ../../mixin/nix.nix
    ../../mixin/sops.nix
    ../../mixin/ssh.nix
    #../../mixin/tailscale.nix
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lorenz.extraGroups = ["docker" "networkmanager"];

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
