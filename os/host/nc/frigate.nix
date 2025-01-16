{config, ...}: let
  hostname = "frigate.leutgeb.xyz";
  port = 7070;
in {
  services = {
    frigate = {
      inherit hostname;
      enable = true;
      settings = {
        mqtt.enabled = false;

        tls.enabled = false;

        record = {
          enabled = true;
          retain = {
            days = 7;
            mode = "all";
          };
          events.retain = {
            default = 30;
            mode = "motion";
          };
        };

        cameras."Engilgasse" = {
          ffmpeg.inputs = [
            {
              path = "rtsp://ghwunv0004:{FRIGATE_RTSP_PASSWORD}@192.168.178.57/mpeg/media.amp";
              #input_args = "preset-rtsp-restream";
              roles = ["record"];
            }
          ];
        };

        #auth.reset_admin_password = true;
        /*
        detectors."ov_0" = {
          type = "openvino";
          device = "CPU";
        };
        */

        timestamp_style = {
          position = "tl";
          format = "%Y-%m-%dT%H:%M:%S%z";
        };
      };
    };
    nginx = {
      enable = true;
      defaultHTTPListenPort = port;
    };
  };

  networking.firewall.allowedTCPPorts = [port];

  sops.secrets.frigate = {
    sopsFile = ./sops/frigate.env;
    format = "binary";
    owner = config.systemd.services.frigate.serviceConfig.User;
  };

  systemd.services.frigate.serviceConfig.EnvironmentFile = config.sops.secrets.frigate.path;

  users.users.frigate.extraGroups = ["keys"];
}
