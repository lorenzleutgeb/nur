{pkgs, ...}: {
  programs.ssh.matchBlocks = {
    "seed.radicle.garden" = {
      host = "seed.radicle.garden";
      user = "seed";
    };
    "ash.radicle.garden" = {
      host = "ash.radicle.garden";
      user = "root";
    };
  };

  home.packages = with pkgs; [
    attic-client
    openssl
    openssl.dev
    pkg-config
  ];
}
