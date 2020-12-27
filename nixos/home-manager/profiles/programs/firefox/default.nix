{ ... }:

with builtins;

{
  programs.firefox = {
    enable = true;

    profiles.default = {
      isDefault = true;
      path = "zemg8lg7.default-1600854037501";

      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.tabs.loadBookmarksInTabs" = true;
        "browser.display.background_color" = "#000000";
      };

      userChrome = readFile ./userChrome.css;
    };
  };
}
