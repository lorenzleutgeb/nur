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

" Ordinal Indicators
"digraphs O1 59001 " superscript 'st', override
"digraphs O2 59002 " superscript 'nd', override
"digraphs O3 59003 " superscript 'rd', override
"digraphs On 59004 " superscript 'th', overrides

" Letterlike Symbols: https://unicode.org/charts/PDF/U2100.pdf
" Mathematical Operators: https://unicode.org/charts/PDF/U2200.pdf
let digraphs = {
      \ 'NN': 0x2115,
      \ 'QQ': 0x211A,
      \ 'RR': 0x211D,
      \ 'ZZ': 0x2124,
      \ 'GG': 0x213E,
      \ 'dd': 0x2146,
      \ 'ee': 0x2147,
      \ 'ii': 0x2148,
      \ 'jj': 0x2149,
      \ '|-': 0x22A2 }

"\ ':=': 0x2254,
" \ 'o+': 0x2295, 'O+': 0x2a01,
" \ 'e$': 0x20ac,
" \ '\|>': 0x21a6,
" \ '[[': 0x27e6, ']]': 0x27e7,
" \ 'aS': 0x1D43, 'bS': 0x1D47, 'cS': 0x1D9C, 'dS': 0x1D48, 'eS': 0x1D49, 'fS': 0x1DA0, 'gS': 0x1D4D, 'hS': 0x02B0, 'iS': 0x2071, 'jS': 0x02B2, 'kS': 0x1D4F, 'lS': 0x02E1, 'mS': 0x1D50, 'nS': 0x207F, 'oS': 0x1D52, 'pS': 0x1D56, 'rS': 0x02B3, 'sS': 0x02E2, 'tS': 0x1D57, 'uS': 0x1D58, 'vS': 0x1D5B, 'wS': 0x02B7, 'xS': 0x02E3, 'yS': 0x02B8, 'zS': 0x1DBB, 'AS': 0x1D2C, 'BS': 0x1D2D, 'DS': 0x1D30, 'ES': 0x1D31, 'GS': 0x1D33, 'HS': 0x1D34, 'IS': 0x1D35, 'JS': 0x1D36, 'KS': 0x1D37, 'LS': 0x1D38, 'MS': 0x1D39, 'NS': 0x1D3A, 'OS': 0x1D3C, 'PS': 0x1D3E, 'RS': 0x1D3F, 'TS': 0x1D40, 'US': 0x1D41, 'VS': 0x2C7D, 'WS': 0x1D42,
" \ 'as': 0x2090, 'es': 0x2091, 'is': 0x1D62, 'os': 0x2092, 'rs': 0x1D63, 'us': 0x1D64, 'vs': 0x1D65, 'xs': 0x2093, 'ys': 0x1D67,
" \ '0S': 0x2070, '1S': 0x00B9, '2S': 0x00B2, '3S': 0x00B3, '4S': 0x2074, '5S': 0x2075, '6S': 0x2076, '7S': 0x2077, '8S': 0x2078, '9S': 0x2079, '+S': 0x207A, '-S': 0x207B, '=S': 0x207C, '(S': 0x207D, ')S': 0x207E,
" \ '0s': 0x2080, '1s': 0x2081, '2s': 0x2082, '3s': 0x2083, '4s': 0x2084, '5s': 0x2085, '6s': 0x2086, '7s': 0x2087, '8s': 0x2088, '9s': 0x2089, '+s': 0x208A, '-s': 0x208B, '=s': 0x208C, '(s': 0x208D, ')s': 0x208E,
" \ '-<':  0x227a, '>-': 0x227b,
" \ 'n#': 0x2115, 'r#': 0x211d, 'z#': 0x2124

"for [dg, code] in items(digraphs)
  "exe 'digraphs ' .. dg .. ' ' .. code
"endfor
