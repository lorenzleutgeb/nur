{
  config,
  pkgs,
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
      extraConfig = {
        url = builtins.listToAttrs (map preferSsh [
          "gitlab.mpi-klsb.mpg.de"
          "github.molgen.mpg.de"
          "gitlab.mpi-sws.org"
        ]);
        "${sub "sendemail" domain}" = {
          smtpUser = user;
          smtpServer = "mail.${domain}";
        };
      };
    };
  };
}
