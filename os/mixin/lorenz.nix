{username ? "lorenz"}: {
  config,
  pkgs,
  ...
}: {
  users.users.${username} = {
    isNormalUser = true;
    description = "Lorenz Leutgeb";
    extraGroups = [
      "audio" # /dev/audio /dev/snd*
      "disk" # /dev/sd*
      "input" # /dev/input/{event,mouse}*
      "kvm" # /dev/kvm

      "plugdev" # udev
      "wheel" # pam_wheel

      config.hardware.cpu.x86.msr.group # https://man7.org/linux/man-pages/man4/msr.4.html
      config.security.tpm2.tssGroup
    ];
    uid = 1000;
    shell = pkgs.dash;
  };
  services.openssh.settings.AllowUsers = [username];
}
