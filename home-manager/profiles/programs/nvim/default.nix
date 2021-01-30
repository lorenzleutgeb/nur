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
    plugins = with pkgs.vimPlugins; [ ];
  };

  xdg.configFile."miv/config.yaml".source = ./config.yaml;

  xdg.configFile."nvim/UltiSnips/tex.snippets".source =
    ./UltiSnips/tex.snippets;

  xdg.configFile."nvim/filetype.vim".source = ./filetype.vim;
  xdg.configFile."nvim/ftplugin/help.vim".source = ./ftplugin/help.vim;
  xdg.configFile."nvim/ftplugin/lp.vim".source = ./ftplugin/lp.vim;

  xdg.configFile."nvim/syntax/lp.vim".source = ./syntax/lp.vim;

  xdg.configFile."nvim/simple.vim".source = ./simple.vim;
}
