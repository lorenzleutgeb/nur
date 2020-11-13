{ ... }:

{
  programs.ssh = {
    enable = true;
    compression = true;

    matchBlocks = {
      rg = {
        hostname = "dev.rising-gods.de";
        port = 2022;
        user = "flowlo";
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
  };
}
