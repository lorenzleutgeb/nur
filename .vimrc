execute pathogen#infect()

syntax enable

set tabstop=4

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

set backup
set backupdir=~/tmp,.,/tmp,~/
set directory=~/tmp,.,/tmp,~/
set writebackup

set colorcolumn=50,70,80,120
highlight ColorColumn ctermbg=black guibg=black
