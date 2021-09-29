" path-based autocommands

function! s:wiresharkdev()
    setlocal makeprg=cmake\ --build\ $BUILDPATH
    let b:ale_c_clangd_options='--compile-commands-dir=$BUILDPATH'
endfunction
augroup wireshark-dev
    autocmd!
    autocmd BufNewFile,BufReadPost,FileReadPost ~/git/wireshark/* call s:wiresharkdev()
augroup END
