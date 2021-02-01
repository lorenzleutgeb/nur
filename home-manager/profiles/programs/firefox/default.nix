{ ... }:

with builtins;

{
  programs.firefox = {
    enable = true;

    profiles.default = {
      isDefault = true;
      path = "zemg8lg7.default-1600854037501";

      settings = {
        # Styling/Interface
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.tabs.loadBookmarksInTabs" = true;
        "signon.rememberSignons" = false;

        # Performance, overall
        "extensions.pocket.enabled" = false;

        # Performance, rendering
        "gfx.webrender.compositor.force-enabled" = true;
        "gfx.webrender.enabled" = true;
        "layers.acceleration.force-enabled" = true;
      };

      userChrome = readFile ./userChrome.css;
    };
  };
}
