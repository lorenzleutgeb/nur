{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../../mixin/kmscon.nix
    ../../mixin/nix.nix
    ../../mixin/sops.nix
    ../../mixin/ssh.nix
    ../../mixin/tailscale.nix
    ../../mixin/dns.nix
    ../../mixin/lorenz.nix
  ];

  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";

  programs = {
    sedutil.enable = true;
    zsh.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      coreutils-full
      lshw
      lsof
      utillinux
      which
      raspberrypi-eeprom
      libraspberrypi
    ];
  };

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

  system.stateVersion = "20.03";

  nixpkgs.hostPlatform = "aarch64-linux";

  security = {
    sudo.wheelNeedsPassword = false;
    pam = {
      u2f = {
        enable = true;
        cue = true;
      };
    };
    rtkit.enable = true;
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
    };
  };

  sops = {
    age.sshKeyPaths = map (x: x.path) config.services.openssh.hostKeys;
    secrets = {
      #"ssh/key".sopsFile = ./sops/ssh.yaml;
    };
  };
}
