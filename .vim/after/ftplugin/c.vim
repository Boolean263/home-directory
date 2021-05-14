
setlocal foldmethod=syntax
setlocal foldnestmax=1

let b:undo_ftplugin .= " | setlocal foldmethod< foldnestmax<"
