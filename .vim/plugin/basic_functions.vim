" Go to the window with this number. Used by diffmode.vim.
function GoWin(num)
    execute a:num." wincmd w"
endfunction

function UndoFTPlugin(str)
    if exists('b:undo_ftplugin')
        let b:undo_ftplugin .= a:str
    else
        let b:undo_ftplugin = a:str
    endif
endfunction
command -nargs=1 UndoFTPlugin call UndoFTPlugin(<args>)

function UndoFTIndent(str)
    if exists('b:undo_indent')
        let b:undo_indent .= a:str
    else
        let b:undo_indent = a:str
    endif
endfunction
command -nargs=1 UndoFTIndent call UndoFTIndent(<args>)


