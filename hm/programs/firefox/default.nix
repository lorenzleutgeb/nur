{
  pkgs,
  super,
  ...
}:
with builtins; {
  home.packages = [pkgs.nssTools];

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

        # Performance (overall)
        "extensions.pocket.enabled" = false;
        "extensions.pocket.oAuthConsumerKey" = "";

        # Performance (decoding and rendering)
        # https://wiki.archlinux.org/index.php/Firefox#Hardware_video_acceleration
        "gfx.webrender.compositor.force-enabled" = true;

        "gfx.webrender.enabled" = true;
        "gfx.webrender.all" = true;
        "layers.acceleration.force-enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.ffmpeg.vaapi-drm-display.enabled" = true;
        "media.ffvpx.enabled" = false;
        "media.av1.enabled" = false;
        "media.rdd-vpx.enabled" = false;
        "media.hardware-video-decoding.force-enabled" = true;

        # Security
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_pbm" = true;

        # Privacy
        # https://wiki.archlinux.org/index.php/Firefox/Privacy
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.pbmode.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.trackingprotection.cryptomining.enabled" = true;
        "network.http.sendRefererHeader" = 0;
        "toolkit.telemetry.enabled" = false;
        "geo.enabled" = false;

        "identity.fxaccounts.account.device.name" = super.networking.hostName;

        "intl.accept_languages" = "en,de,it,fr";

        # CSS
        # Note that backdrop-filter also requires gfx.webrender.all (above).
        "layout.css.backdrop-filter.enabled" = true;
      };

      userChrome = readFile ./userChrome.css;
    };
  };
}
