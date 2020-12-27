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

" Digraphs
digr NN  8469 " natural  numbers
digr QQ  8474 " rational numbers
digr RR  8477 " real     numbers
digr ZZ  8484 " integer  numbers
digr :=  8788 " colon equals
digr !-  8866 " turnstile

"" Ordinal Indicators
digr O1 59001 " superscript 'st', override
digr O2 59002 " superscript 'nd', override
digr O3 59003 " superscript 'rd', override
digr On 59004 " superscript 'th', overrides
