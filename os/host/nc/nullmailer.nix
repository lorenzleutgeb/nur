{config, ...}: {
  sops.secrets.nullmailer = {
    sopsFile = ./sops/nullmailer;
    format = "binary";
    owner = config.services.nullmailer.user;
  };

  services.nullmailer = {
    enable = true;
    setSendmail = true;
    remotesFile = config.sops.secrets.nullmailer.path;
    config = {
      me = "nc.leutgeb.xyz";
      defaultdomain = "leutgeb.xyz";
      adminaddr = "lorenz@leutgeb.xyz";
    };
  };
}
