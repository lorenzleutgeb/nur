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
            "2a03:4000:6:10ea::1" # netcup
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
            address = [
              # NOTE: Looks like ns1.he.net prefers to receive zone updates via IPv4?
              # "2001:470:100::2"
              "216.218.130.2"
            ];
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
            id = "1984.is";
            address = "93.95.224.6";
          }
          {
            id = "quad9";
            address = ["2620:fe::fe" "2620:fe::9" "9.9.9.9" "149.112.112.112"];
          }
          {
            id = "hetzner";
            address = [
              "213.239.242.238"
              "213.133.100.103"
              "193.47.99.3"
              "2a01:4f8:0:a101::a:1"
              "2a01:4f8:0:1::5ddc:2"
              "2001:67c:192c::add:a3"
            ];
          }
        ];

        remotes = [
          {
            id = "notify";
            remote = [
              "ns1.he.net"
              "ns2.afraid.org"
              "1984.is"
              "hetzner"
            ];
          }
          {
            id = "transfer";
            remote = [
              "slave.dns.he.net"
              "ns2.afraid.org"
              "1984.is"
              "hetzner"
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
            acl = [
              "transfer"
              "acme"
            ];
          }
        ];

        zone = let
          primary = {domain, ...} @ args:
            {
              file = "${path}/${domain}.zone";
              template = "primary";
            }
            // args;
        in [
          (primary {
            domain = "falsum.org";
            dnssec-signing = true;
          })
          (primary {
            domain = "leutgeb.xyz";
            dnssec-signing = true;
          })
          (primary {domain = "leutgeb.wien";})
          (primary {
            domain = "salutas.org";
            dnssec-signing = true;
          })
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
