{ super, ... }:

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
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.uidensity" = 1;
        "browser.urlbar.oneOffSearches" = false;
        "browser.urlbar.update2.oneOffsRefresh" = false;
        "signon.rememberSignons" = false;

        # Performance, overall
        "extensions.pocket.enabled" = false;
        "extensions.pocket.oAuthConsumerKey" = "";

        # Performance, rendering
        "gfx.webrender.compositor.force-enabled" = true;
        "gfx.webrender.enabled" = true;
        "layers.acceleration.force-enabled" = true;

        # Security
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_pbm" = true;

        # Privacy
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.pbmode.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.trackingprotection.cryptomining.enabled" = true;

        "identity.fxaccounts.account.device.name" = super.networking.hostName;
      };

      userChrome = readFile ./userChrome.css;
    };
  };
}
