" Turn on 'crosshairs' to highlight current cursor location when
" nothing's going on. Turn them off again when unneeded to speed rendering.

function! s:ShowCrosshairs()
    set cursorline cursorcolumn
endfunction

function! s:HideCrosshairs()
    set nocursorline nocursorcolumn
endfunction

augroup crosshairs
    autocmd!
    autocmd CursorHold,CursorHoldI * call s:ShowCrosshairs()
    autocmd CursorMoved,CursorMovedI * call s:HideCrosshairs()
augroup END
