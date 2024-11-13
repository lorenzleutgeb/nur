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

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
  };
}
