{
  lib,
  pkgs,
  config,
  modulesPath,
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
    #./git.nix
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

    ./disk-config.nix

    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    kernel.sysctl."net.ipv4.ip_forward" = 1;
    loader.systemd-boot.enable = true;

    initrd.availableKernelModules = [
      "ata_piix"
      "uhci_hcd"
      "virtio_pci"
      "sr_mod"
      "virtio_blk"

      "ahci"
      "xhci_pci"
      "virtio_scsi"
      "sd_mod"
    ];
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
    inherit domain;
    hostName = "nc";
    useNetworkd = true;
    useDHCP = false;
  };

  systemd.network = let
    device = "ens3";
  in {
    enable = true;
    networks."10-netcup" = {
      matchConfig.Name = "ens3";
      address = [
        "152.53.113.87/22"
        "2a0a:4cc0:80:42c6::1/128"
      ];
      gateway = [
        "152.53.112.1"
        "fe80::1"
      ];
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
    yggdrasil = {
      enable = true;
      persistentKeys = true;
      settings.Peers = [
        "tcp://ygg-uplink.thingylabs.io:80"
        "tls://109.176.250.101:65534"
        "tcp://vpn.itrus.su:7991"
      ];
    };
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
