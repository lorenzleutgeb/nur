{
  pkgs,
  osConfig,
  ...
}: let
  cache = "mob";
in {
  home.packages = with pkgs; [alejandra espeak-classic mob];

  systemd.user.services.cachix-watch-store = {
    Unit = {
      Description = "Cachix watching the store";
      After = ["network-online.target"];
    };
    Service = {
      Restart = "on-failure";
      RestartSec = "1";
      Environment = "PATH=${osConfig.nix.package}/bin";
      ExecStart = "${pkgs.cachix}/bin/cachix watch-store ${cache}";
    };
  };
}
