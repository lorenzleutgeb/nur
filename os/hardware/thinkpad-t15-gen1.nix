# See also https://github.com/NixOS/nixos-hardware/tree/master/lenovo/thinkpad
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [<nixos-hardware/lenovo/thinkpad>];

  # Configure boot

  # Configure file systems including swap

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
