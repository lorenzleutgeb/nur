{
  services.tor = {
    enable = true;
    enableGeoIP = false;
    openFirewall = true;
    relay.role = "private-bridge";
    settings = {
      ORPort = "auto";
      ClientUseIPv6 = true;
    };
    client.enable = true;
  };
}
