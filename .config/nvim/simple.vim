" This file contains simple configurations meant to be compatible
" with all three flavours: Vim, NeoVim, IdeaVim
"
" Not supported:
" autocmd
" augroup
" Plugin System

let mapleader="\<space>"
" Just to make clear that the local leader key is bacslash.
let maplocalleader="\\"

" Use system keyboard by default and registers if some text
" should be protected.
set clipboard^=unnamed,unnamedplus
