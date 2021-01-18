" Inspired by https://gist.github.com/tpope/287147
"
" Intended use:
"     inoremap <silent> <Bar>   <Bar><C-O>:call Tablify('|')<CR>

if ! exists(':Tab')
    finish
endif

function! Tablify(sym)
  if sym == '<Bar>'
      sym = "|"
  endif
  let p = '^\s*'.sym.'\s.*\s'.sym.'\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*'.sym && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^'.sym.']','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*'.sym.'|\s*\zs.*'))
    exec 'Tabularize/'.sym.'/l1'
    normal! 0
    call search(repeat('[^'.sym.']*'.sym,column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction
