{
  pkgs,
  config,
  ...
}: {
  boot = {
    # Add two v4l devices "v4l-0" and "v4l-1" that map to /dev/video1{0,1}.
    extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
    extraModprobeConfig = "options v4l2loopback exclusive_caps=1 video_nr=10,11 card_label=v4l-0,v4l-1";
  };
  environment.systemPackages = with pkgs; [v4l-utils];
}
