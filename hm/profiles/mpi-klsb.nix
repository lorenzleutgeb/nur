{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  sub = section: subsection: ''${section} "${subsection}"'';
  user = "lorenz";
  domain = "mpi-inf.mpg.de";
  email = "${user}@${domain}";
  identity = {
    user.email = email;
    sendemail.identity = domain;
  };
  dir = hostname: {
    condition = "gitdir:~/src/${hostname}/";
    contents = identity;
  };
  preferSsh = hostname: {
    name = "ssh://git@${hostname}/";
    value.insteadOf = "https://${hostname}/";
  };
  known = ".ssh/known_hosts_mpi-klsb";
in {
  home = {
    file = {
      ".ssh/config_mpi-klsb" = {
        text = ''
          Match host *.mpi-inf.mpg.de,*.mpi-sws.org,*.mpi-klsb.mpg.de
            # Do not blindly accept known hosts for any domain,
            # but restrict to well-known domains.
            UserKnownHostsFile ~/${known}

          Match host *.mpi-inf.mpg.de,!contact.mpi-inf.mpg.de !exec "ip -4 -o a show up scope global | grep 139.19."
            ProxyJump contact.mpi-inf.mpg.de
        '';
        target = ".ssh/config_mpi-klsb.orig";
        onChange = ''cat .ssh/config_mpi-klsb.orig > .ssh/config_mpi-klsb && chmod 400 .ssh/config_mpi-klsb'';
      };
    };
    packages = with pkgs; [subversion];
    shellAliases."update-known-hosts" = "curl --silent 'https://ca.mpi-klsb.mpg.de/ssh_known_hosts' -o \"${config.home.homeDirectory}/${known}\"";
  };

  programs = {
    ssh.includes = ["~/.ssh/config_mpi-klsb"];
    git = {
      includes = builtins.map dir [
        "gitlab.mpi-klsb.mpg.de"
        "github.molgen.mpg.de"
        "gitlab.mpi-sws.org"
        "git.rg1.mpi-inf.mpg.de"
      ];
      settings = {
        url =
          (builtins.listToAttrs (map preferSsh [
            "gitlab.mpi-klsb.mpg.de"
            "github.molgen.mpg.de"
            "gitlab.mpi-sws.org"
          ]))
          // {
            "ssh://git@gitlab.mpi-klsb.mpg.de/info/git.rg1/".insteadOf = "rg1:";
          };
        "${sub "sendemail" domain}" = {
          smtpUser = user;
          smtpServer = "mail.${domain}";
        };
      };
    };
  };

  systemd.user = {
    services."anti-opsi".Service = {
      Type = "oneshot";
      ExecStart = (lib.getExe (pkgs.writeShellApplication {
        name = "anti-opsi";
	runtimeInputs = with pkgs; [ curl jq ];
	text = ''
	  OUTPUT="/mnt/c/Users/lorenz/anti-opsi/thunderbird.msi"
	  curl \
	    --time-cond "$OUTPUT" \
	    --output "$OUTPUT" \
	    --max-time 120 \
	    --location "https://download.mozilla.org/?product=thunderbird-$(curl -H 'accept: application/json' "https://query.wikidata.org/sparql?query=$(jq -r '@uri' <<<"\"SELECT ?version WHERE { wd:Q483604 p:P348 ?versionStatement. ?versionStatement ps:P348 ?version; pq:P548 wd:Q2804309; pq:P577 ?date. } ORDER BY DESC(?date) LIMIT 1\"")" | jq -r .results.bindings[0].version.value)-msi-SSL&os=win64&lang=en-US"
	'';
      }));
    };

    timers."anti-opsi" = {
      Timer = {
        OnBootSec = "10m";
        OnUnitActiveSec = "24h";
      };
      Install.WantedBy = ["timers.target"];
    };
  };
}
