{
  pkgs,
  config,
  ...
}:
with builtins; {
  home = {
    packages = with pkgs; [
      #neovim-remote
      powerline-fonts
    ];
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    extraConfig = readFile ./init.vim;
    plugins = with pkgs.vimPlugins; [
      gruvbox
      tex-conceal-vim
      vim-airline
      vim-easyescape
      vimtex
    ];
  };

  xdg.configFile = {
    "nvim/UltiSnips/tex.snippets".source = ./UltiSnips/tex.snippets;
    "nvim/filetype.vim".source = ./filetype.vim;
    "nvim/ftplugin/help.vim".source = ./ftplugin/help.vim;
    "nvim/ftplugin/lp.vim".source = ./ftplugin/lp.vim;
    "nvim/syntax/lp.vim".source = ./syntax/lp.vim;
    "nvim/simple.vim".source = ./simple.vim;
  };
}
