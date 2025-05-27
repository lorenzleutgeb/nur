{...}: {
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
}
