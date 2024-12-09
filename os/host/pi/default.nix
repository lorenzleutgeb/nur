{
  config,
  pkgs,
  hardware,
  ...
}: {
  imports = [
    ../../mixin/kmscon.nix
    ../../mixin/nix.nix
    ../../mixin/sops.nix
    ../../mixin/ssh.nix
    ../../mixin/tailscale.nix
    ../../mixin/dns.nix
    (import ../../mixin/lorenz.nix {})
    "${hardware}/raspberry-pi/4"
  ];

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "uas"];
  };

  hardware.raspberry-pi."4" = {
    dwc2 = {
      enable = true;
      dr_mode = "host";
    };
  };

  # mkpasswd
  # import readline
  # readline.write_history_file = lambda *args: None
  # import crypt
  # print(crypt.crypt("PASSWORD", "PREFIX"))
  users.users.lorenz.hashedPassword = "$y$j9T$iCkJnWJNPOl5wU6JdPDEX.$7H1eWUtbdLubzaNuyCySqup9sjCq4z7i0Dzac5xTX/1";

  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";

  programs = {
    sedutil.enable = true;
    zsh.enable = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
  };

  environment = {
    systemPackages = with pkgs; [
      coreutils-full
      lshw
      lsof
      utillinux
      which
      wget
      zstd
      raspberrypi-eeprom
      libraspberrypi
    ];
  };

  networking.hostName = "pi";

  services = {
    openssh = {
      enable = true;
      settings.X11Forwarding = true;
      hostKeys = [
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };
    tailscale.enable = true;
    resolved.enable = true;
  };

  nixpkgs = {
    hostPlatform = "aarch64-linux";
    overlays = [
      # https://github.com/NixOS/nixpkgs/issues/126755#issuecomment-869149243
      (final: super: {
        makeModulesClosure = x: super.makeModulesClosure (x // {allowMissing = true;});
      })
    ];
  };

  security = {
    sudo.wheelNeedsPassword = false;
    pam = {
      u2f = {
        enable = true;
        settings.cue = true;
      };
    };
    rtkit.enable = true;
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };

  sops = {
    age.sshKeyPaths = map (x: x.path) config.services.openssh.hostKeys;
    secrets = {
      #"ssh/key".sopsFile = ./sops/ssh.yaml;
    };
  };
}
