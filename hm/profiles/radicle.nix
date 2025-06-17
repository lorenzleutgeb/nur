{pkgs, ...}: {
  home.packages = with pkgs; [
    attic-client
    openssl
    openssl.dev
    pkg-config
  ];
}
