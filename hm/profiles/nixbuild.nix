{
  pkgs,
  lib,
  ...
}: {
  programs = {
    ssh.matchBlocks."nixbuild.net" = {
      hostname = "eu.nixbuild.net";
      extraOptions = {RemoteCommand = "shell";};
    };
  };
  home.shellAliases.nixbuild = "${lib.getExe pkgs.rlwrap} ssh nixbuild.net";
}
