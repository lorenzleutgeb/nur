{
  config,
  lib,
  pkgs,
  ...
}:
with builtins; let
  username = "lorenz";
in {
  imports = [
    ../../mixin/dns.nix
    ../../mixin/fonts.nix
    (import ../../mixin/lorenz.nix {inherit username;})
    #../../mixin/mkcert
    ../../mixin/mpi-klsb.nix
    ../../mixin/nix.nix
    ../../mixin/sops.nix
    ../../mixin/ssh.nix
    #../../mixin/yggdrasil.nix
    #./tor.nix
    #../../mixin/tailscale.nix
  ];

  hardware.graphics.enable = true;

  wsl = {
    enable = true;
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
    envfs.enable = true;
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
  users.users.lorenz.extraGroups = ["docker"];

  nixpkgs.hostPlatform = "x86_64-linux";

  #nix.settings.substituters = ["https://0mqr.fluffy-ordinal.ts.net/cache/?trusted=true"];

  networking = {
    hosts."202:f094:502b:1b03:9e0:2c3d:bc8b:428b" = ["yggdrasil.seed.leutgeb.xyz"]; # Work around rad:z3gqcJUoA1n9HaHKufZs5FCSGazv5/issue/608341c7ec80555e4b16050ab25c8d5be6322e18
    firewall.enable = false;
    hostName = "wsl";
    useDHCP = false;
  };

  security = {
    sudo.wheelNeedsPassword = false;
    pam = {
      u2f = {
        enable = false;
        settings.cue = true;
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
    network.enable = true;
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
