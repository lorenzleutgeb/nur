final: prev: {
  polybar = prev.polybar.override {
    pulseSupport = true;
    libpulseaudio = prev.libpulseaudio;
    # githubSupport = true; curl          = prev.curl;
    # mpdSupport    = true; mpd_clientlib = prev.mpd_clientlib;
    nlSupport = true;
    libnl = prev.libnl;
    i3Support = true;
    i3 = prev.i3;
    jsoncpp = prev.jsoncpp;
  };
}
