{pkgs, ...}: {
  home.file.".ssh/config_dns".text = ''
  '';

  programs.ssh = {
    enable = true;
    compression = true;
    hashKnownHosts = true;

    matchBlocks = {
      remarkable = {
        # Static Mapping for d4:12:43:dd:a9:a4
        hostname = "192.168.144.154";
        user = "root";
      };
      "1gh3" = {
        hostname = "100.80.204.123";
        port = 9022;
        user = "u0_a297";
      };
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

      "0mqr.falsum.org".proxyCommand = "${pkgs.cloudflared}/bin/cloudflared access ssh --hostname %h";
    };
    extraConfig = ''
      VerifyHostKeyDNS yes
      VisualHostkey yes
    '';
  };
}
