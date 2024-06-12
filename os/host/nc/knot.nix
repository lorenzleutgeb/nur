{
  pkgs,
  config,
  inputs,
  ...
}: let
  writeZone = name: text: pkgs.writeText "${name}.zone" text;

  acme = domain: ns:
    writeZone "_acme-challenge.${domain}" ''
      $TTL 600
      @ IN SOA _acme-challenge.${domain}. ${ns}. 2024060801 7200 3600 86400 3600
        IN NS  ${ns}.
    '';

  update = domain: ns:
    writeZone "${domain}" ''
      $TTL 600
      @ IN SOA ${domain}. ${ns}. 2024060801 7200 3600 86400 3600
        IN NS  ${ns}
    '';

  keys = ["acme" "he"];

  path = ./. + "/zone";
in {
  networking.firewall = let
    dns = [53];
  in {
    allowedTCPPorts = dns;
    allowedUDPPorts = dns;
  };

  sops.secrets = builtins.listToAttrs (map (key: {
      name = "knot/${key}";
      value = {
        sopsFile = ./sops + "/${key}.yaml";
        owner = "knot";
        format = "binary";
      };
    })
    keys);

  services = {
    caddy.virtualHosts."dns.leutgeb.xyz".extraConfig = ''
      root /zone/* ${path}
      root * /var/www/dns.leutgeb.xyz
      encode zstd gzip
      file_server
    '';

    knot = {
      enable = true;

      keyFiles = map (key: config.sops.secrets."knot/${key}".path) keys;

      settings = {
        server = {
          listen = [
            "5.45.105.177" # netcup
            "2a03:4000:6:10ea:54b5:3dff:fe79:b5b9" # netcup
            "100.96.0.2" # tailnet
            "fd7a:115c:a1e0:e00::2" # tailnet
          ];

          automatic-acl = true;
        };

        remote = [
          {
            id = "slave.dns.he.net";
            address = ["2001:470:600::2" "216.218.133.2"];

            # NOTE: Sadly does not work.
            # ACL, allowed, action query, remote …, key 1fc…zzm.
            # TSIG, key '1fc…zzm.', verification failed 'BADSIG'
            #key = "1FCTMVl4ITuOsxyYmWFymxz8VhXMzzZM";
          }
          {
            id = "ns1.he.net";
            address = ["2001:470:100::2" "216.218.130.2"];
          }
          {
            id = "ns2.afraid.org";
            address = [
              "69.65.50.192"

              # NOTE: afraid.org seems to only pull and allow our A, but not AAAA records.
              #"2001:1850:1:5:800::6b"
            ];
          }
          {
            id = "puck.nether.net";
            address = [
              "2602:fe55:5::5"

              # NOTE: Only our IPv6 is allowlisted on their end.
              #"204.42.254.5"
            ];
          }
          {
            id = "1984.is";
            address = "93.95.224.6";
          }
          {
            id = "quad9";
            address = ["2620:fe::fe" "2620:fe::9" "9.9.9.9" "149.112.112.112"];
          }
        ];

        remotes = [
          {
            id = "notify";
            remote = [
              "ns1.he.net"
              "ns2.afraid.org"
              "puck.nether.net"
              "1984.is"
            ];
          }
          {
            id = "transfer";
            remote = [
              "slave.dns.he.net"
              "ns2.afraid.org"
              "puck.nether.net"
              "1984.is"
            ];
          }
        ];

        log = [
          {
            target = "syslog";
            any = "debug";
          }
        ];

        acl = [
          {
            id = "transfer";
            action = [
              "query"
              "transfer"
            ];
            remote = "transfer";
          }
          {
            id = "acme";
            action = "update";
            key = "acme";
          }
          {
            id = "tailnet";
            action = [
              "transfer"
              "update"
            ];
            address = config.services.headscale.settings.ip_prefixes;
          }
        ];

        mod-rrl = [
          {
            id = "default";
            rate-limit = 500;
            slip = 2;
          }
        ];

        mod-dnsproxy = [
          {
            id = "default";
            remote = "quad9";
            fallback = true;
          }
        ];

        template = [
          {
            id = "default";
            semantic-checks = "on";
            global-module = [
              "mod-rrl/default"
              #"mod-dnsproxy/default"
            ];
            zonefile-load = "difference-no-serial";
            zonefile-sync = "-1";
            journal-content = "all";
          }
          {
            id = "primary";
            notify = "notify";
            acl = ["transfer" "tailnet"];
            dnssec-signing = true;
          }
        ];

        zone = let
          primary = domain: {
            inherit domain;
            file = "${path}/${domain}.zone";
            template = "primary";
          };
        in [
          (primary "falsum.org")
          (primary "leutgeb.xyz")
          (primary "leutgeb.wien")
        ];
      };
    };
  };
  systemd = {
    services.knot-status = {
      serviceConfig.Type = "oneshot";
      script = builtins.readFile ./knot-status.sh;
      scriptArgs = "/var/www/dns.leutgeb.xyz/index.html";
      wants = ["knot.service"];
      requires = ["knot.service"];
      path = with pkgs; [
        dnsutils # for dig
        yq
        jq
        coreutils
        diffutils
        pandoc
      ];
    };
    timers.knot-status = {
      timerConfig = {
        OnCalendar = "*:0/30";
        RandomizedDelaySec = "5min";
        Unit = "knot-status.service";
      };
      wantedBy = ["timers.target"];
    };
  };
}
