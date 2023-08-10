{pkgs, ...}: {
  programs = {
    ssh.matchBlocks."nixbuild.net" = {
      hostname = "eu.nixbuild.net";
      extraOptions = {RemoteCommand = "shell";};
    };
    zsh.shellAliases.nixbuild = "${pkgs.rlwrap}/bin/rlwrap ssh nixbuild.net";
  };
}
