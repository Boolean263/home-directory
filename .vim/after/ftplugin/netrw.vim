" netrw "helpfully" remaps S-Up and S-Down
" see :help netrw-starstar
if exists(':TmuxNavigateLeft')
    nnoremap <buffer> <silent> <S-Left> :<C-U>TmuxNavigateLeft<cr>
    nnoremap <buffer> <silent> <S-Right> :<C-U>TmuxNavigateRight<cr>
    nnoremap <buffer> <silent> <S-Up> :<C-U>TmuxNavigateUp<cr>
    nnoremap <buffer> <silent> <S-Down> :<C-U>TmuxNavigateDown<cr>
endif
