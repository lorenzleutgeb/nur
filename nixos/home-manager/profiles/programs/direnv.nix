{ ... }:

{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableNixDirenvIntegration = true;
    config = { global = { strict_env = true; }; };
  };
}
