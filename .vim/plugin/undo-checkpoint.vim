function UndoCPSave()
    let b:undo_cp = undotree().seq_cur
endfunction
function UndoCPRestore()
    if exists('b:undo_cp')
        let l:undo_cp = undotree().seq_cur
        execute "".b:undo_cp."undo"
        let b:undo_cp = l:undo_cp
    else
        echohl ErrorMsg
        echo "No saved undo spot"
        echohl None
    endif
endfunction
nnoremap <leader>U :call UndoCPSave()<CR>
nnoremap <leader>u :call UndoCPRestore()<CR>
au! BufReadPost * if &modifiable | call UndoCPSave() | endif
