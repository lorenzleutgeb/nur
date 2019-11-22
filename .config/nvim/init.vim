set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

let mapleader="\<space>"
" Just to make clear that the local leader key is bacslash.
let maplocalleader="\\"

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

set wildmenu " visual autocomplete for command menu

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

setlocal spell
set spelllang=en_us

" vim-plug Section

" See Commands at https://github.com/junegunn/vim-plug#commands

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')

Plug 'wellle/targets.vim'

Plug 'zhou13/vim-easyescape'
	let g:easyescape_chars = { "j": 2 }
	let g:easyescape_timeout = 300
	cnoremap jj <ESC>

"Plug 'Valloric/YouCompleteMe'
Plug 'vim-syntastic/syntastic'

Plug 'rust-lang/rust.vim'
	let g:rustfmt_autosave = 0

Plug 'https://framagit.org/tyreunom/coquille.git'

" https://github.com/gillescastel/latex-snippets/tree/58721391f6423444c58f7cc63a5b490a4c6f9cfb
Plug 'sirver/Ultisnips'
	let g:UltiSnipsExpandTrigger = '<tab>'
	let g:UltiSnipsJumpForwardTrigger = '<tab>'
	let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

Plug 'lervag/vimtex'
	let g:tex_flavor='latex'
	let g:vimtex_view_method='zathura'
	let g:vimtex_quickfix_mode=0

Plug 'KeitaNakamura/tex-conceal.vim'
	set conceallevel=1
	let g:tex_conceal='abdmg'

Plug 'liuchengxu/vim-clap'
" Older alternative in case vim-clap is too buggy:
"Plug 'junegunn/fzf', { 'dir': '~/.vim-fzf', 'do': './install --bin' }
"Plug 'junegunn/fzf.vim'

" Initialize plugin system
call plug#end()

" Coq / coquille
command Cc call CoqToCursor()
command Cn call CoqNext()
command Cu call CoqUndo()
command Ca call CoqCancel()
command Cs call CoqStop()
command Cl call CoqLaunch()

let g:coquille_auto_move = 'true'
