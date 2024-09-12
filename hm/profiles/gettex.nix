{
  config,
  lib,
  pkgs,
  ...
}: let
  pkg = pkgs.gettex;
in {
  home.packages = [pkg pkgs.zindex];

  systemd.user = {
    timers."gettex" = {
      Unit.Description = "gettex Timer";
      Timer.OnCalendar = "Mon..Fri 09,11,13,15,17,19,21:45:00";
      Install.WantedBy = ["timers.target"];
    };
    services."gettex" = {
      Unit.Description = "gettex";
      Service = {
        Type = "oneshot";
        ExecStart = lib.getExe (pkgs.writeShellApplication rec {
          name = "gettex-script";
          meta.mainProgram = name;
          runtimeInputs = with pkgs; [zindex gettex sqlite jq coreutils];
          text = ''
            gettex fetch
            gettex query-all
            cp -v "$XDG_DATA_HOME/gettex/all.json" "/var/www/lorenz.leutgeb.xyz/gettex.json"
          '';
        });
      };
      Install.WantedBy = ["default.target"];
    };
  };

  xdg.configFile = {
    "gettex/isin".text = builtins.concatStringsSep "\n" [
      "CH1102728750" # 21Shares       Cardano
      "DE000GX5LS95" # Goldman Sachs  Fixed Income
      "IE00B4L60045" # iShares        EUR Corporate Bond
      "IE00BCRY6557" # iShares        Ultrashort Bond
      "IE00BDZZTM54" # iShares        MSCI World SRI
      "IE00BGDQ0T50" # iShares        EM SRI
      "IE00BGL86Z12" # iShares        Electric Vehicles and Driving Technology
      "IE00BYYHSM20" # iShares        MSCI Europe Quality Dividend
      "LU0335044896" # Xtrackers      Overnight Rate Swap
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
