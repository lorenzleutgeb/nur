{ pkgs, ... }:

{
  home = {
    file.".thunderbird/q3qx3d7w.default/chrome/userChrome.css".source =
      ./userChrome.css;
    packages = [ pkgs.thunderbird ];
  };
}
