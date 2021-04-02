{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    intel-gpu-tools
    libva-utils
    #vdpauinfo
  ];

  hardware = {
    opengl = {
      # NOTE: Couldn't get VDPAU via VAAPI to work. Probably don't need it.
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        #libvdpau
        #libvdpau-va-gl
      ];
    };
  };
}
