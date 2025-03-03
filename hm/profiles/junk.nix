{
  pkgs,
  lib,
  config,
  ...
}: {
  accounts.email = {
    maildirBasePath = "mail";

    accounts.lorenz = {
      primary = true;
      address = "lorenz@leutgeb.xyz";
    };

    accounts.junk = {
      address = "lorenz@leutgeb.xyz";
      userName = "lorenz-junk@leutgeb.xyz";

      imap = {
        host = "imap.migadu.com";
        port = 993;
      };

      realName = "Lorenz Leutgeb";

      maildir.path = "junk";

      passwordCommand = "${pkgs.coreutils}/bin/cat \"\${XDG_RUNTIME_DIR}/secrets/junk/password\"";

      mbsync = {
        enable = true;
        create = "both";
        groups.junk.channels = {
          domain = {
            nearPattern = "domain";
            farPattern = "Junk/domain";
            extraConfig.Create = "both";
          };
          sender = {
            nearPattern = "sender";
            farPattern = "Junk/sender";
            extraConfig.Create = "both";
          };
        };
      };
    };
  };

  programs.mbsync.enable = true;

  services.mbsync = {
    enable = true;
    # TODO: Make this less brittle.
    postExec = "${lib.getExe pkgs.python311} ${config.home.homeDirectory}/src/github.com/lorenzleutgeb/junk/junk.py";
  };

  sops.secrets."junk/password" = {};
}
