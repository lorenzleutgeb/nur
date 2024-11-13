{config, ...}: let
  hostname = "frigate.leutgeb.xyz";
in {
  services = {
    frigate = {
      inherit hostname;
      enable = true;
      settings = {
        mqtt.enabled = false;

        record = {
          enabled = true;
          retain = {
            days = 2;
            mode = "all";
          };
        };

        cameras."Engilgasse" = {
          ffmpeg.inputs = [
            {
              path = "rtsp://ghwunv0004:{FRIGATE_RTSP_PASSWORD}@192.168.178.57/mpeg/media.amp";
              input_args = "preset-rtsp-restream";
              roles = ["record"];
            }
          ];
        };
      };
    };
    nginx = {
      enable = true;
      defaultHTTPListenPort = 7070;
    };
  };

  sops.secrets.frigate = {
    sopsFile = ./sops/frigate.env;
    format = "binary";
    owner = config.systemd.services.frigate.serviceConfig.User;
  };

  systemd.services.frigate.serviceConfig.EnvironmentFile = config.sops.secrets.frigate.path;

  users.users.frigate.extraGroups = ["keys"];
}
