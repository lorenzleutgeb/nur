{
  lib,
  pkgs,
  config,
  ...
}:
with builtins; let
  domain = "leutgeb.xyz";
  alternateDomain = "falsum.org";
  subdomain = name: name + "." + domain;
in {
  imports = [
    #./jitsi.nix
    ../../mixin/caddy.nix
    ../../mixin/dns.nix
    ../../mixin/kmscon.nix
    (import ../../mixin/lorenz.nix {})
    ../../mixin/nix.nix
    ../../mixin/progressive.nix
    #../../mixin/remote-build.nix
    ../../mixin/sops.nix
    ../../mixin/ssh.nix
    ../../mixin/tailscale.nix
    ./caddy.nix
    ./git.nix
    #./headscale.nix
    ./knot.nix
    ./mta-sts.nix
    #./nfs.nix
    #./nextcloud.nix
    ./nullmailer.nix
    ./tor.nix
    #./frigate.nix
    ./unifi.nix
    ./vaultwarden.nix
    ./wireguard.nix
    #./keycloak.nix
    #./authentik.nix
  ];

  fileSystems =
    (builtins.listToAttrs (map
      ({
        subvol,
        mountpoint ? "/${subvol}",
      }: {
        name = mountpoint;
        value = {
          device = "/dev/disk/by-uuid/6906f221-06ca-4db2-befc-5f4052ed8348";
          fsType = "btrfs";
          options = ["compress=zstd" "discard=async" "noatime" "subvol=${subvol}"];
        };
      }) [
        {
          mountpoint = "/";
          subvol = "root";
        }
        {subvol = "home";}
        {subvol = "nix";}
      ]))
    // {
      "/boot" = {
        device = "/dev/disk/by-uuid/2AB6-5830";
        fsType = "vfat";
      };
    };

  boot = {
    kernel.sysctl."net.ipv4.ip_forward" = 1;
    loader.systemd-boot.enable = true;

    initrd.availableKernelModules = [
      "ata_piix"
      "uhci_hcd"
      "virtio_pci"
      "sr_mod"
      "virtio_blk"
    ];
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
    hostName = "nc";
  };

  systemd.network = let
    device = "ens3";
  in {
    enable = true;
    networks."10-${device}" = {
      matchConfig.Name = device;
      networkConfig = {
        IPv6AcceptRA = true;
        Address = [
          "5.45.105.177/22"
          "2a03:4000:6:10ea:54b5:3dff:fe79:b5b9/64"
        ];
      };
      gateway = ["5.45.104.1"];
      dns = config.services.resolved.fallbackDns;
    };
  };

  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    binutils
    coreutils
    exfat
    fuse
    lsof
    pflogsumm
    utillinux
    vim
    wget
    which
    zip
  ];

  networking.firewall.allowedTCPPorts = [
    22 # sshd
    #25 # postfix (SMTP)
    #465 # dovecot/postfix ? (SMTP over TLS)
    #993 # dovecot (IMAP over TLS)
    8384 # syncthing HTTP
    8776 # radicle node
  ];

  #extraVirtualAliases.${localMail "theres-und-lorenz"} = ["theressophie@gmail.com" "${me.email}"];

  services = {
    fail2ban.enable = true;
    qemuGuest.enable = true;
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        MaxAuthTries = 3;
        LoginGraceTime = 20;
        PermitEmptyPasswords = "no";
      };
      # Only listen on Tailscale interface.
      # If Tailscale goes down, recover access via netcup vServer Control Panel.
      /*
      listenAddresses = [
        {
          addr = "100.104.93.77";
          port = 22;
        }
      ];
      */
    };
  };

  users = {
    mutableUsers = false;
    users = {
      lorenz.hashedPassword = "$6$rJZSLnQH1hInB93$lfi4c2zxQbSJV7H9T9lrjOj6WIDhSEqP5FyjMinEE44j81E1l57hF6Epyxb02EbcWqDT9eYbyo4dBTAwewBgQ/";
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";

  programs.ssh.startAgent = true;

  security.sudo.wheelNeedsPassword = false;

  sops.age.sshKeyPaths = map (x: x.path) config.services.openssh.hostKeys;
}
