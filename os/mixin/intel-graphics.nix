{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-gpu-intel
  ];

  environment.systemPackages = with pkgs; [
    intel-gpu-tools
    libva-utils
    vdpauinfo
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
