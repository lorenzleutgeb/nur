{...}: {
  programs.ssh.matchBlocks = {
    "seed.radicle.{garden,xyz}" = {
      host = "seed.radicle.garden seed.radicle.xyz";
      user = "seed";
    };
    "ash.radicle.garden" = {
      host = "ash.radicle.garden";
      user = "root";
    };
  };
}
