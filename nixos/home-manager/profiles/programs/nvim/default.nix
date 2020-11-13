{ pkgs, ... }:

with builtins;

{
  home.packages = [ pkgs.neovim-remote ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = readFile ./init.vim;
    plugins = with pkgs.vimPlugins; [
      editorconfig-vim
      jq-vim
      lightline-vim
      rust-vim
      sved
      targets-vim
      ultisnips
      vimtex
      vim-easy-align
      vim-eunuch
      vim-gitgutter
      vim-multiple-cursors
      vim-surround
    ];
  };
}
