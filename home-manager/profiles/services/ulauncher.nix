{ pkgs, ... }:

{
  services.ulauncher = {
    enable = true;
    config = {
      extensions = {
        "com.github.rdnetto.ulauncher-sway" = pkgs.fetchFromGitHub {
          owner = "rdnetto";
          repo = "ulauncher-sway";
          rev = "ca6e8365723fd444b302236fb72eded4a1378c3e";
          sha256 = "0ac8g30wx181bjqgi2wsccdjvzybqfjalh1pn7sjb2bw3mh594cn";
        };
        "com.github.behrensger.dict_cc_ulauncher" = pkgs.fetchFromGitHub {
          owner = "behrensger";
          repo = "dict_cc_ulauncher";
          rev = "f6c60536fad95d1e32bc92a9c73911f3664e6fe1";
          sha256 = "18six6xv3dabxlfgchm72r8avjzb0zn4rgi874p3pqr22rwww56c";
        };
      };
      settings = {
        "clear-previous-query" = true;
        "hotkey-show-app" = "<Primary>space";
        "render-on-screen" = "mouse-pointer-monitor";
        "show-indicator-icon" = true;
        "show-recent-apps" = "0";
        "terminal-command" = "";
        "theme-name" = "dark";
      };
    };
  };
}

/* {
       "c7226db6-9598-4be8-8098-4945eef03504": {
           "id": "c7226db6-9598-4be8-8098-4945eef03504",
           "name": "Google Search",
           "keyword": "g",
           "cmd": "https://google.com/search?q=%s",
           "icon": "~/.nix-profile/share/ulauncher/media/google-search-icon.png",
           "is_default_search": true,
           "run_without_argument": false,
           "added": 1616075474.304699
       },
       "a69404a1-67b9-4d5d-b093-daf5bf5bc3e7": {
           "id": "a69404a1-67b9-4d5d-b093-daf5bf5bc3e7",
           "name": "Stack Overflow",
           "keyword": "so",
           "cmd": "http://stackoverflow.com/search?q=%s",
           "icon": "~/.nix-profile/share/ulauncher/media/stackoverflow-icon.svg",
           "is_default_search": true,
           "run_without_argument": false,
           "added": 1616075474.3047323
       },
       "7dc5f7f0-326f-47a4-a33f-b92a1d616d41": {
           "id": "7dc5f7f0-326f-47a4-a33f-b92a1d616d41",
           "name": "Wikipedia",
           "keyword": "wiki",
           "cmd": "https://en.wikipedia.org/wiki/%s",
           "icon": "~/.nix-profile/share/ulauncher/media/wikipedia-icon.png",
           "is_default_search": true,
           "run_without_argument": false,
           "added": 1616075474.304759
       }
   }
*/
