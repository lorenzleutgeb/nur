{pkgs, ...}: {
  home.packages = [pkgs.ffmpeg];

  systemd.user.services."v4lbridge" = {
    Unit = {Description = "video4linux Webcam Bridge";};
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.ffmpeg}/bin/ffmpeg -i /dev/video0 -vcodec rawvideo -pix_fmt yuv420p -vsync 2 -threads 0 -f v4l2 /dev/video11";
      Restart = "on-failure";
    };
  };
}
