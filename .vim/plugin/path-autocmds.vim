" path-based autocommands

" For my Wireshark development, I souce ~/env/wireshark.env
" which defines several env vars such as $WS_BIN_PATH.
if exists('$WS_BIN_PATH')
    function! s:wiresharkdev()
        " set up `:make`
        setlocal makeprg=cmake\ --build\ $BUILDPATH

        " set up `gf`/`:find` to look for filenames
        " in the Wireshark source tree
        setlocal path-=. path^=.,$SRCPATH/**

        " set up sections for my sectional-couch plugin
        " https://github.com/Boolean263/sectional-couch.vim
        if exists('g:sectional_couch')
            setl sections=/^{/\ /^}/
        endif

        " Short commands for running in the debugger
        packadd termdebug
        command! TSDB execute 'Termdebug '.$WS_BIN_PATH.'/tshark'
        command! WSDB execute 'Termdebug '.$WS_BIN_PATH.'/wireshark'
    endfunction
    augroup wireshark-dev
        autocmd!
        autocmd BufNewFile,BufReadPost,FileReadPost $SRCPATH/* call s:wiresharkdev()
    augroup END
endif
