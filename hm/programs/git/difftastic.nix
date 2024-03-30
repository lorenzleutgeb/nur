{
  config,
  lib,
  pkgs,
  ...
}: let
  pkg = pkgs.difftastic;
  cfg = config.programs.git;
  cmd = lib.concatStringsSep " " [
    "${lib.getExe pkg}"
    "--color ${cfg.difftastic.color}"
    "--background ${cfg.difftastic.background}"
    "--display ${cfg.difftastic.display}"
  ];
in {
  home.packages = [pkg];
  programs.git.extraConfig = {
    diff = {
      tool = "difftastic";
      external = cmd;
    };
    difftool.prompt = "false";
    "difftool \"difftastic\"".cmd = "${cmd} \"$LOCAL\" \"$REMOTE\"";
    pager.difftool = "true";
  };
}
