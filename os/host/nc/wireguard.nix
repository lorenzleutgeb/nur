{config, ...}: let
  user = "systemd-network";
in {
  users.users.${user}.extraGroups = ["keys"];

  sops.secrets = {
    "fritz/psk" = {
      owner = user;
      sopsFile = ./sops/fritz.yaml;
    };
    "fritz/pk" = {
      owner = user;
      sopsFile = ./sops/fritz.yaml;
    };
  };

  systemd.network = {
    enable = true;
    netdevs."80-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
        MTUBytes = "1300";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."fritz/pk".path;
      };
      wireguardPeers = [
        {
          wireguardPeerConfig = {
            PublicKey = "k3u9msA9b6WsO1mHg1B3F5p8d+mk01KPColOXDDbhC4=";
            AllowedIPs = "192.168.178.0/24";
            PersistentKeepalive = 25;
            PresharedKeyFile = config.sops.secrets."fritz/psk".path;
            Endpoint = "viuyg7910fd1t4dq.myfritz.net:55750";
          };
        }
      ];
    };
    networks.engilgasse = {
      matchConfig.Name = "wg0";
      address = ["192.168.178.204/24"];
      DHCP = "no";
      gateway = [
        "192.168.178.1"
      ];
      networkConfig = {
        IPForward = "yes";
      };
    };
  };
}
