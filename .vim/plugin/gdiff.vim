" Create a Gdiff command that calls my qfdiff.sh wrapper
" (see ~/.config/git/qfdiff.sh)

function! s:qdiff(...)
    cexpr system('git difftool --tool=qfdiff '.join(a:000, " "))
endfunction

command! -nargs=* Gdiff call s:qdiff(<q-args>)
command! -nargs=* Gcdiff call s:qdiff('--command', <q-args>)

