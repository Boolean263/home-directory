" Settings etc. for the quick-fix and location-list windows
" https://vimways.org/2018/colder-quickfix-lists/

" When the quickfix window is open, switch through the quickfix history
" with the arrow keys.
" See also autoload/quickfixed.vim
if exists("g:loaded_qf")
    nmap <silent> <buffer> <Left> <Plug>(qf_older)
    nmap <silent> <buffer> <Left> <Plug>(qf_newer)
else
    nnoremap <silent> <buffer> <Left> :call quickfixed#older()<CR>
    nnoremap <silent> <buffer> <Right> :call quickfixed#newer()<CR>
endif

" Moving through the quickfix window, j/k should move normally
nnoremap <buffer> j j
nnoremap <buffer> k k

" Close the window from within it
nnoremap <buffer> <Leader>q :cclose<CR>
nnoremap <buffer> <Leader>l :lclose<CR>

" Pressing Enter on a line should open that line in an editor window
" (not the quickfix window)! This is supposedly the default but it's
" acting strange for me so I'm making it explicit.
nnoremap <buffer> <Enter> :.cc<Enter>
