{
  pkgs,
  osConfig,
  ...
}: {
  home.packages = with pkgs; [alejandra espeak-classic mob];

  systemd.user.services = with builtins;
    listToAttrs (map (cache: {
      name = "cachix-watch-store@${cache}";
      value = {
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
    }) ["mob" "ngi"]);
}
