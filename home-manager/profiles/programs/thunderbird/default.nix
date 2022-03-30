{ pkgs, ... }:

{
  # Until there's a module for Thunderbird, use Preferences / Config Editor
  # intl.date_time.pattern_override.date_short = yyyy-MM-dd
  home = {
    file.".thunderbird/q3qx3d7w.default/chrome/userChrome.css".source =
      ./userChrome.css;
    packages = [ pkgs.thunderbird ];
  };
}
