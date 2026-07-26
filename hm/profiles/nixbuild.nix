{
  pkgs,
  lib,
  ...
}: {
  programs.ssh.settings."nixbild.net" = {
    HostName = "eu.nixbuild.net";
    RemoteCommand = "shell";
  };
  home.shellAliases.nixbuild = "${lib.getExe pkgs.rlwrap} ssh nixbuild.net";
}
