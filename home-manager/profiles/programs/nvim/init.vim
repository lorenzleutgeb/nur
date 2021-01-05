" Configuration shared with other Vims,
" such as IdeaVim, is placed here.
source ~/.config/nvim/simple.vim

set title

" This enables the miv plugin manager.
filetype off
if has('vim_starting')
  " set rtp^=~/.vim/miv/miv
  " or when you set $XDG_DATA_HOME,
  set rtp^=$XDG_DATA_HOME/miv/miv
endif
filetype plugin indent on

let &packpath = &runtimepath

" Make file search more powerful
set path+=**
set path+=$PWD/**
set wildmenu " visual autocomplete for command menu
set wildignore+=**/node_modules/**
set wildignore+=**/build/**

set t_8f=[38;2;%lu;%lu;%lum
set t_8b=[48;2;%lu;%lu;%lum
set termguicolors

set guifont=Fira\ Code:h13

command! MakeTags !ctags -R .

" Automatically source rc if saving a vim file.
if has ('autocmd') " Remain compatible with earlier versions
 augroup vim       " Source vim configuration upon save
    autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
    autocmd! BufWritePost $MYGVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | redraw
  augroup END
endif " has autocmd

set nocp
filetype plugin on

set hidden

syntax enable

" Hybrid line numbers as presented in
" https://jeffkreeftmeijer.com/vim-number/
set number relativenumber

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

set tabstop=8

set cursorline " highlight current line

filetype indent on " load filetype-sepific indent files

set lazyredraw " redraw only when we need to

set showmatch " oh yeah, matching braces

set incsearch " incremental search

set hlsearch " highlight matches when searching

" move up and down visually
nnoremap j gj
nnoremap k gk

map <leader>tt :tabedit %<cr>

" inoremap jj <Esc>

" Unwanted Whitespace via https://vim.fandom.com/wiki/Highlight_unwanted_spaces

" Define an annoying highlight to avoid extra whitespace.
:highlight ExtraWhitespace ctermbg=red guibg=red

" Show trailing whitespace and spaces before a tab:
:match ExtraWhitespace /\s\+$\| \+\ze\t/

set backup
set backupdir=~/tmp,.,/tmp,~/
set directory=~/tmp,.,/tmp,~/
set writebackup

set colorcolumn=50,70,80,120
highlight ColorColumn ctermbg=black guibg=black

" To navigate to cursor position (especially epic with eye tracking)
set mouse=a

" setlocal spell
set spelllang=en_us

let g:tex_flavor = 'latex'
let g:latex_view_general_viewer = 'zathura'
