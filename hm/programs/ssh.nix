{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings."*" = {
      Compression = true;
      HashKnownHosts = true;
      VerifyHostKeyDNS = true;
    };
  };
}
