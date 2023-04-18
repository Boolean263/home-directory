" Customizations on top of dracula colorscheme
runtime colors/dracula.vim

"highlight CursorLine   term=none cterm=none ctermbg=238 guibg=#222222
"highlight CursorLine NONE
highlight CursorLine   term=underline cterm=underline ctermbg=NONE guibg=NONE gui=undercurl
highlight CursorColumn term=none cterm=none ctermbg=238 guibg=#222222
highlight ColorColumn  term=none cterm=none ctermbg=235 guibg=#0F0F0F
highlight LineNr       term=underline cterm=none ctermfg=3 ctermbg=0 guifg=Yellow guibg=Black
highlight CursorLineNr term=inverse cterm=none ctermfg=0 ctermbg=11 guifg=#000000 guibg=#FFFF00
" CursorLineNr applies to the current line number only if relativenumber
" is set, or if number AND cursorline are both set. cursorline and
" relativenumber both slow vim down. Hopefully, "highlight CursorLine NONE"
" mitigates that somewhat.

"highlight DiffDelete   term=none cterm=none ctermfg=0 ctermbg=52 guifg=black guibg=#5F0000
"highlight DiffAdd      term=none cterm=none ctermbg=22 guibg=#005F00
"highlight DiffChange   term=none cterm=none ctermbg=17 guibg=#00005F
"highlight DiffText     term=underline cterm=underline ctermbg=20 guibg=#0000D7
