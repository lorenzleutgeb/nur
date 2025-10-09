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
    ../../mixin/systemd.nix
    #../../mixin/yggdrasil.nix
    ./tor.nix
    #../../mixin/tailscale.nix
  ];

  hardware.graphics.enable = true;

  wsl = {
    enable = true;
    wslConf = {
      user.default = username;
      automount = {
        enabled = false;
        mountFsTab = false;
      };
      network = {
        generateHosts = false;
        generateResolvConf = false;
      };
      interop = {
        enabled = true;
        appendWindowsPath = false;
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
  };

  fileSystems."/mnt/c" = {
    device = "C:";
    fsType = "drvfs";
    options = [
      "uid=${builtins.toString config.users.users.lorenz.uid}"
      "gid=${builtins.toString config.users.groups.${config.users.users.lorenz.group}.gid}"
      #"x-systemd.automount"
      #"x-systemd.mount-timeout=5s"
    ];
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
    unprivilegedUsernsClone = true;
  };

  virtualisation = {
    podman.enable = true;
    docker = {
      enable = false;
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
    #network.enable = true;

    network = let
      nics = [
        {
          order = "30";
          name = "eth0";
          matchConfig.PermanentMACAddress = "38:f3:ab:f3:7c:1e";
        }
        {
          order = "50";
          name = "wlan0";
          matchConfig.PermanentMACAddress = "58:6c:25:b3:98:27";
        }
        {
          order = "80";
          name = "uni";
          matchConfig.PermanentMACAddress = "00:e0:4c:68:03:39";
        }
      ];
    in {
      enable = true;
      wait-online = {
        ignoredInterfaces = map (x: x.name) (builtins.filter (x: !(x.wait or false)) nics);
        timeout = 5;
      };
      /*
      links = builtins.listToAttrs (map (nic: {
          name = "${nic.order}-${nic.name}";
          value = {
            inherit (nic) matchConfig;
            linkConfig =
              {
                Name = nic.name;
              }
              // (nic.linkConfig or {});
          };
        })
        nics);

      networks = builtins.listToAttrs (map (nic: {
          inherit (nic) name;
          value = {
            enable = true;
            inherit (nic) matchConfig;
            networkConfig = {
              IPv6AcceptRA = true;
       DNSSEC = "yes";
       DNSOverTLS = "yes";
            };
            dns = config.services.resolved.fallbackDns;
            dhcpV4Config = {
              UseDNS = false;
              UseRoutes = true;
              UseHostname = false;
              UseDomains = true;
            };
          };
        })
        nics);
      */
    };
  };
}
