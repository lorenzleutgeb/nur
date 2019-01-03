set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

syntax enable

set tabstop=8

set cursorline " highlight current line

filetype indent on " load filetype-sepific indent files

set wildmenu " visual autocomplete for command menu

set lazyredraw " redraw only when we need to

set showmatch " oh yeah, matching braces

set incsearch " incremental search

set hlsearch " highlight matches when searching

" move up and down visually
nnoremap j gj
nnoremap k gk

" inoremap jj <Esc>

set backup
set backupdir=~/tmp,.,/tmp,~/
set directory=~/tmp,.,/tmp,~/
set writebackup

set colorcolumn=50,70,80,120
highlight ColorColumn ctermbg=black guibg=black

call plug#begin('~/.local/share/nvim/plugged')
Plug 'zhou13/vim-easyescape'
call plug#end()

let g:easyescape_chars = { "j": 1, "k": 1 }
let g:easyescape_timeout = 100
cnoremap jk <ESC>
cnoremap kj <ESC>
