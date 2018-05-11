" Go to the window with this number. Used by diffmode.vim.
function! GoWin(num)
    execute a:num." wincmd w"
endfunction
