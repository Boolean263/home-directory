" I can't easily use/test plugin features in `~/.vim/vimrc` because they
" aren't loaded until after that file has been completed. So this file is for
" enabling features based on particular plugin configs.

if exists(':BufExplorer')
    nnoremap <leader>b :BufExplorer<CR>
endif

if exists(':ALENext')
    nnoremap ]e :ALENext<cr>
    nnoremap [e :ALEPrevious<cr>
endif

if exists('g:loaded_altr')
    " Can't use nnoremap for <Plug> mappings
    nmap ]r <Plug>(altr-forward)
    nmap [r <Plug>(altr-back)
endif
