{pkgs, ...}: {
  home.file.".ssh/config_dns".text = ''
  '';

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        compression = true;
        hashKnownHosts = true;
      };
      "1gh3" = {
        hostname = "100.80.204.123";
        port = 9022;
        user = "u0_a297";
      };
      os = {
        hostname = "ssh.tilab.tuwien.ac.at";
        user = "y112784";
      };
      db = {
        hostname = "bordo.dbai.tuwien.ac.at";
        user = "u112784";
      };
      fp = {
        hostname = "g0.complang.tuwien.ac.at";
        user = "f112784";
      };
      ub = {
        hostname = "g0.complang.tuwien.ac.at";
        user = "u112748";
      };
      ad = {
        hostname = "behemoth.ads.tuwien.ac.at";
        user = "e1127842";
      };
    };
    extraConfig = ''
      VerifyHostKeyDNS yes
    '';
  };
}
