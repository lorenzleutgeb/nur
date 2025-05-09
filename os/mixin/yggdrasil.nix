{
  services.yggdrasil = {
    enable = true;
    persistentKeys = true;
    # https://github.com/yggdrasil-network/public-peers
    settings.Peers = [
      "tcp://ygg-uplink.thingylabs.io:80" # Germany
      "tls://109.176.250.101:65534" # Austria
      "tcp://vpn.itrus.su:7991" # The Netherlands
      "tls://[2a03:90c0:85::28a]:443" # Luxembourg
    ];
  };
}
