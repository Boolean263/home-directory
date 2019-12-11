" Settings etc. for the quick-fix and location-list windows
" https://vimways.org/2018/colder-quickfix-lists/

" When the quickfix window is open, switch through the quickfix history
" with the arrow keys.
" See also autoload/quickfixed.vim
nnoremap <silent> <buffer> <Left> :call quickfixed#older()<CR>
nnoremap <silent> <buffer> <Right> :call quickfixed#newer()<CR>

" Moving through the quickfix window, j/k should move normally
nnoremap <buffer> j j
nnoremap <buffer> k k
