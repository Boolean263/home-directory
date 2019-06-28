" Mappings and whatnot specific to running vim in diff mode (gvimdiff)
if ! &diff
    finish
endif

" Make the input windows non-modifiable
call GoWin(1)
setlocal nomodifiable readonly
call GoWin(2)
setlocal nomodifiable readonly
call GoWin(3)
setlocal nomodifiable readonly

" Just in case
call GoWin(4)
setlocal modifiable noreadonly

" Needed this at work, may not want it at home
set nowrapscan

" Resize all panes whenever the window is resized
augroup vimdiff
    autocmd!
    autocmd VimResized * wincmd =
augroup END

"Keyboard shortcuts to switch between windows
nnoremap <silent> <Leader>1 :call GoWin(1)<cr>
nnoremap <silent> <Leader>2 :call GoWin(2)<cr>
nnoremap <silent> <Leader>3 :call GoWin(3)<cr>
nnoremap <silent> <Leader>4 :call GoWin(4)<cr>

"Put current diff to the final product
nnoremap <silent> <Leader>p :diffput 4 \| diffupdate<cr>
vnoremap <silent> <Leader>p :diffput 4 \| diffupdate<cr>

nnoremap <silent> <Leader>u :diffupdate<cr>

" Make sure I'm saving the right file, regardless of what window I'm in
nnoremap <silent> <Leader>w :call GoWin(4) \| w<cr>
nnoremap <Leader>q :qa<cr>
