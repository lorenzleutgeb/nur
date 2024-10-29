{osConfig, ...}:
assert osConfig.services.tor.enable;
assert osConfig.services.tor.client.enable; {
  programs.git.includes = [
    {
      condition = "hasconfig:remote.*.url:*.onion:*/**";
      contents.http.proxy = "socks5://[::1]:9050";
    }
  ];
}
