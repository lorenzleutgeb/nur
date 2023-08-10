{pkgs, ...}: {
  home.packages = [
    pkgs.signal-desktop
    (pkgs.makeDesktopItem {
      name = "signal-desktop-scaled";
      exec = "${pkgs.signal-desktop}/bin/signal-dekstop --no-sandbox --force-device-scale-factor=1.5 %U";
      comment = "Private messaging from your desktop";
      genericName = "Messenger";
      desktopName = "Signal @1.5";
      categories = ["Network" "InstantMessaging" "Chat"];
      mimeTypes = ["x-scheme-handler/sgnl"];
      terminal = false;
      icon = "signal-desktop";
      type = "Application";
    })
  ];
}
