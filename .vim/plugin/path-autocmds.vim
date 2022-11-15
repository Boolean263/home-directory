" path-based autocommands

function! s:wiresharkdev()
    setlocal makeprg=cmake\ --build\ $BUILDPATH
    let b:ale_c_clangd_options='--compile-commands-dir=$BUILDPATH'
    if exists('g:sectional_couch')
        setl sections=/^{/\ /^}/
    endif
    packadd termdebug
    command! TSDB execute 'Termdebug '.$BUILDPATH.'/run/tshark'
    command! WSDB execute 'Termdebug '.$BUILDPATH.'/run/wireshark'
endfunction
augroup wireshark-dev
    autocmd!
    autocmd BufNewFile,BufReadPost,FileReadPost ~/git/wireshark/* call s:wiresharkdev()
augroup END
