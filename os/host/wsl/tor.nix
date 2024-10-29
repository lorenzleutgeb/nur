{
  services.tor = {
    enable = true;
    enableGeoIP = false;
    openFirewall = true;
    relay = {
      role = "private-bridge";
      onionServices = {
        "radicle".map = [
          {port = 8776;}
          {port = 8000;}
        ];
      };
    };
    settings = {
      ORPort = "auto";
      ClientUseIPv6 = true;
    };
    client.enable = true;
  };
}
