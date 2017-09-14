" Try using this with:
" export MANPAGER=...
setlocal nomod
setlocal readonly
setlocal nolist
setlocal nospell
setlocal nonumber norelativenumber
setlocal nomodifiable
setlocal noswapfile
setlocal buftype=nofile
setlocal bufhidden=hide

"This part doesn't seem to work
function! PrepManPager()
    setlocal modifiable
    if !empty ($MAN_PN)
        silent %! col -b -x
    endif
    setlocal nomodified
    setlocal nomodifiable
endfunction
autocmd BufWinEnter $MAN_PM call PrepManPager()

nnoremap <buffer> q :qa!<CR>
nnoremap <buffer> <end> G
nnoremap <buffer> <home> gg
nnoremap <buffer> <space> <PageDown>

