
let hostname = "jitsi.leutgeb.xyz"; in
{
  networking.firewall = {
    allowedUDPPorts = [
      5349
      5350
    ];

    allowedTCPPorts = [
      3478
      3479
    ];
  };

  services = {
    nginx.virtualHosts.${hostname} = {
      enableACME = false;
      forceSSL = true;
      useACMEHost = "leutgeb.xyz-wildcard";
    };
    jitsi-meet = {
      enable = true;
      hostName = hostname;
    };
    jitsi-videobridge = {
      openFirewall = true;
    };
  };
}
