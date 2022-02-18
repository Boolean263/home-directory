
setlocal foldmethod=syntax
setlocal foldnestmax=1

" Enable automatic C program indenting;
" see also 'cinkeys', 'cinwords', and 'cinoptions' (the latter is used in my vimrc)
setlocal cindent

let b:undo_ftplugin .= " | setlocal foldmethod< foldnestmax< cindent<"
