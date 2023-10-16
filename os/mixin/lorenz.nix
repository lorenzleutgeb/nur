{pkgs, ...}: {
  users.users.lorenz = {
    isNormalUser = true;
    createHome = true;
    home = "/home/lorenz";
    description = "Lorenz Leutgeb";
    extraGroups = [
      "audio" # /dev/audio /dev/snd*
      "disk" # /dev/sd*
      "input" # /dev/input/{event,mouse}*
      "kvm" # /dev/kvm

      "plugdev" # udev
      "wheel" # pam_wheel
      "msr" # https://man7.org/linux/man-pages/man4/msr.4.html
    ];
    uid = 1000;
    shell = pkgs.zsh;
  };

  services.tailscale.namespace = "lorenz";
}
