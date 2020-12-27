{ pkgs, ... }:

with builtins;

{
  home.packages = with pkgs; [
    neovim-remote
    haskellPackages.miv
    powerline-fonts
  ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = readFile ./init.vim;
    plugins = with pkgs.vimPlugins; [];
  };
}
