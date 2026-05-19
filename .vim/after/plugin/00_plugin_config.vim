" I can't easily use/test plugin features in `~/.vim/vimrc` because they
" aren't loaded until after that file has been completed. So this file is for
" enabling features based on particular plugin configs.

if exists(':BufExplorer')
    nnoremap <leader>b :BufExplorer<CR>
    let g:bufExplorerFindActive=0 " always bring selected buffer into the current window
    let g:bufExplorerOnlyOneTab=0 " Show in all tabs where buffer was used.
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

if exists(':TmuxNavigateLeft')
    nnoremap <silent> <S-Left> :<C-U>TmuxNavigateLeft<cr>
    nnoremap <silent> <S-Right> :<C-U>TmuxNavigateRight<cr>
    nnoremap <silent> <S-Up> :<C-U>TmuxNavigateUp<cr>
    nnoremap <silent> <S-Down> :<C-U>TmuxNavigateDown<cr>
endif
