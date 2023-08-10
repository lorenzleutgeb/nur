{...}: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {global = {strict_env = true;};};
  };

  xdg.configFile."direnv/lib/layout.sh" = {
    text = builtins.readFile ./layout.sh;
    executable = true;
  };
}
