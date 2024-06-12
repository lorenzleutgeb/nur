let
  hostname = "jitsi.leutgeb.xyz";
in {
  networking.firewall = {
    allowedUDPPorts = [5349 5350];
    allowedTCPPorts = [3478 3479];
  };

  services = {
    jitsi-meet = {
      enable = true;
      hostName = hostname;
    };
    jitsi-videobridge = {openFirewall = true;};
  };
}
