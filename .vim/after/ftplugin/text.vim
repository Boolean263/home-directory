setlocal linebreak
setlocal nocursorcolumn

call textobj#sentence#init()

let b:undo_ftplugin .= ' |setlocal linebreak< cursorcolumn<'
