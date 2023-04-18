" Options for browsing vim internal help files
setlocal foldcolumn=0
let b:undo_ftplugin .= " | setlocal foldcolumn<"
if version > 742
    setlocal signcolumn=no
    let b:undo_ftplugin .= " | setlocal signcolumn<"
endif
if exists(':IndentGuidesDisable')
    IndentGuidesDisable
    let b:undo_ftplugin .= " | IndentGuidesEnable"
endif
