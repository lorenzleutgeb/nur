{ pkgs, ... }:

{
  programs.thunderbird = {
    enable = true;
    settings = {
      "intl.date_time.pattern_override.date_short" = "yyyy-MM-dd";
    };
    profiles."lorenz" = {
      isDefault = true;
      userChrome = ''
        * {
          font-size: 14px !important;
          font-family: 'Fira Sans', sans-serif;
        }
      '';
    };
  };
}