{ pkgs, ... }:

{
  home.packages = with pkgs; [
    spotify

    /* (makeDesktopItem {
         name = "spotify";
         exec = "${spotify}/bin/spotify";
         comment = "Spotify Music Player";
         desktopName = "Spotify";
         genericName = "Music Player";
         categories = "Audio";
       })
    */

    (makeDesktopItem {
      name = "spotify-scaled";
      exec = "spotify --force-device-scale-factor=2 %U";
      comment = "Spotify Music Player for 4K displays";
      desktopName = "Spotify @2";
      genericName = "Music Player";
      categories = "Audio;Music;Player;AudioVideo;";
      mimeType = "x-scheme-handler/spotify;";
      terminal = false;
      icon = "spotify-client";
      type = "Application";
      #tryExec = "spotify";
    })
  ];
}
