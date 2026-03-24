{
  services.tor = {
    enable = true;
    enableGeoIP = false;
    openFirewall = true;
    relay = {
      enable = true;
      role = "private-bridge";
    };
    settings = {
      ORPort = "auto";
      ClientUseIPv6 = true;
    };
    client.enable = true;
  };
}
