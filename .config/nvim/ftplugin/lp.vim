" ---------------------------------------------------------------
" VIM Syntax file for Answer Set Programming 
" (specifically, clasp from http://potassco.sourceforge.net/)
"
" Author: Sean Policarpio
" Date: 30.08.2012
" ---------------------------------------------------------------

if version < 600
   syntax clear
elseif exists("b:current_syntax")
  finish
endif

" PATTERN MATCHING
syn match bad_fact '[\s]\?[A-Z]\+[0-9a-zA-Z]*\.'

syn match atom '[a-z0-9]\+[0-9a-zA-Z]*' containedin=rule_body nextgroup=atom_brackets
syn region atom_brackets start='(' end=')' transparent contains=predicate_term,predicate_variable

syn region rule_body contains=atom start=':-' end='\.' transparent

syn match predicate_term contained containedin=atom_brackets '[a-z0-9]\+[0-9a-zA-Z]*'
syn match predicate_variable contained containedin=atom_brackets '[A-Z]\+[0-9a-zA-Z]*'

syn match const '#const.*$'
syn match hide '#hide.*$'
syn match comment '%.*$'


syn match lower_bound_choice '\d{'
syn match upper_bound_choice '}\d'

syn match bad_fact '^[A-Z]\+[0-9a-zA-Z]*\s'


" HIGHLIGHTING
highlight link const                 PreProc
highlight link hide                  PreProc
highlight link comment               Comment
highlight link predicate_term        Character
highlight link predicate_variable    Identifier
highlight link atom                  Statement
highlight link fact                  Type
highlight link bad_fact              Error
highlight link lower_bound_choice    Number
highlight link upper_bound_choice    Number
