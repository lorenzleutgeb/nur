{ ... }:

{
  home.file.".ssh/config_dns".text = ''
    VerifyHostKeyDNS yes
  '';

  home.file.".ssh/config_jumphost".text = ''
    Match host *.mpi-inf.mpg.de,!contact.mpi-inf.mpg.de !exec "ip -4 -o a show up scope global | grep 139.19."
      ProxyJump contact.mpi-inf.mpg.de
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
    };
    includes =
      [ "/home/lorenz/.ssh/config_dns" "/home/lorenz/.ssh/config_jumphost" ];
  };
}
