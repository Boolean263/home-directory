" Try using this with:
" export MANPAGER=$HOME/bin/manpager

setlocal nomod
setlocal readonly
setlocal nolist
setlocal nospell
setlocal nonumber norelativenumber
setlocal nomodifiable
setlocal noswapfile
setlocal buftype=nofile
setlocal bufhidden=hide
setlocal foldcolumn=0
if version > 742
    setlocal signcolumn=no
endif

nnoremap <buffer> q :qa!<CR>
nnoremap <buffer> <end> G
nnoremap <buffer> <home> gg
nnoremap <buffer> <space> <PageDown>

let b:undo_ftplugin .= "setlocal mod< readonly< list< spell<"
    \ . " number< relativenumber< modifiable< swapfile< buftype< bufhidden<"
    \ . " foldcolumn< "
if version > 742
    let b:undo_ftplugin .=" signcolumn<"
endif

let b:undo_ftplugin .= ""
    \ . " |silent! nunmap <buffer> q"
    \ . " |silent! nunmap <buffer> <end>"
    \ . " |silent! nunmap <buffer> <home>"
    \ . " |silent! nunmap <buffer> <space>"

if exists(':IndentGuidesDisable')
    IndentGuidesDisable
    let b:undo_ftplugin .= " | IndentGuidesEnable"
endif
