" Customizations on top of "plain.vim"
runtime colors/plain.vim

highlight Normal ctermfg=251 ctermbg=234 guifg=#CCCCCC guibg=#222222
highlight clear SignColumn
highlight SignColumn term=none cterm=none ctermbg=black guibg=black
highlight clear GitGutterAdd
highlight clear GitGutterDelete
highlight clear GitGutterChange
highlight clear GitGutterChangeDelete
highlight GitGutterAdd term=standout ctermfg=green guifg=green guibg=black
highlight GitGutterChange term=standout ctermfg=yellow guifg=yellow guibg=black
highlight GitGutterDelete term=standout ctermfg=red guifg=red guibg=black 
highlight link GitGutterChangeDelete GitGutterChange

highlight clear CursorColumn
highlight link CursorColumn CursorLine

highlight Pmenu guibg=#000000 ctermbg=0 term=standout
