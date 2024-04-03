{
  config,
  lib,
  pkgs,
  ...
}: let
  pkg = pkgs.gettex;
in {
  home.packages = [pkg];

  systemd.user = {
    timers."gettex" = {
      Unit.Description = "gettex Timer";
      Timer = {
        OnCalendar = "Mon..Fri 09,11,13,15,17,19,21:45:00";
        WantedBy = "timers.target";
      };
    };
    services."gettex" = {
      Unit.Description = "gettex Fetch";
      Service = {
        Type = "oneshot";
        ExecStart = "${lib.getExe pkg} fetch";
      };
    };
  };

  xdg.configFile = {
    "gettex/isin".text = builtins.concatStringsSep "\n" [
      "IE00BGL86Z12"
      "IE00BGDQ0T50"
      "IE00BYYHSM20"
      "IE00BDZZTM54"
      "NL0015000N74"
      "DE000GX5LS95"
      "IE00BCRY6557"
      "LU0335044896"
      "CH1102728750"
    ];
    "gettex/zindex.json".text =
      builtins.toJSON
      {
        indexes = [
          {
            type = "field";
            delimiter = ",";
            fieldNum = 1;
          }
        ];
      };
  };
}
