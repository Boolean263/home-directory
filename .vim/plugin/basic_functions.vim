" Go to the window with this number. Used by diffmode.vim.
function GoWin(num)
    execute a:num." wincmd w"
endfunction

function UndoFTPlugin(str)
    if exists('b:undo_ftplugin')
        let b:undo_ftplugin .= "|".a:str
    else
        let b:undo_ftplugin = a:str
    endif
endfunction
command! -nargs=1 UndoFTPlugin call UndoFTPlugin(<args>)

function UndoFTIndent(str)
    if exists('b:undo_indent')
        let b:undo_indent .= a:str
    else
        let b:undo_indent = a:str
    endif
endfunction
command! -nargs=1 UndoFTIndent call UndoFTIndent(<args>)

function UndoFT(...)
    exe join(a:000, " ")
    let l:cmd = a:1
    let l:args = a:000[1:]
    if l:cmd == "setl" || l:cmd == "setlocal"
        let l:undostr = "setlocal"
        for arg in args
            let l:undostr .= " "
                \ . substitute(arg, '\v(^no|[=].*$)', '', 'g')
                \ . "<"
        endfor
        call UndoFTPlugin(l:undostr)
    elseif match(l:cmd, 'map!\?$') != -1
        let l:matches = matchlist(l:cmd, '^\v([nvxsoilct]?)(no)?(re)?(map)(!)?')
        let l:undostr = l:matches[1] . "unmap"
        let l:i = 0
        while 1 == match(l:args[l:i], '\v<(buffer|nowait|silent|script|expr|unique)>')
            let l:undostr .= " ".l:args[l:i]
            let l:i += 1
        endwhile
        let l:undostr .= " ".l:args[l:i]
    endif
    call UndoFTPlugin(l:undostr)

endfunction
command! -nargs=+ UndoFT call UndoFT(<f-args>)
