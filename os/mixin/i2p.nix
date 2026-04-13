{
  services.i2pd = {
    enable = true;
    enableIPv6 = true;
    proto.socksProxy.enable = true;
    proto.http.enable = true;
  };
}
