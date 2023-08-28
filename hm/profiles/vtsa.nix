{pkgs, ...}: {
  home.packages = with pkgs; [quint apalache];

  systemd.user.services.apalache = {
    Unit = {
      Description = "Apalache verificiation server";
      After = ["network-online.target"];
    };
    Service = {
      Restart = "on-failure";
      RestartSec = "1";
      Environment = "PATH=${pkgs.coreutils}/bin";
      ExecStart = "${pkgs.apalache}/bin/apalache-mc server";
    };
  };
}
