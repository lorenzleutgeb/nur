{
  services.tor = {
    enable = true;
    enableGeoIP = false;
    openFirewall = true;
    relay = {
      #enable = true;
      role = "private-bridge";
      onionServices = {
        "radicle".map = [
          { port = 8776; }
          { port = 80; }
        ];
        "http".map = [
          { port = 80; }
        ];
      };
    };
    settings = {
      ORPort = "auto";
      ClientUseIPv6 = true;
    };
  };
}
