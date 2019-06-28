" Special options for editing vim files like .vimrc

" Let the K hotkey look up the keyword in Vim's help
setlocal keywordprg=:help

" Source the current file
nnoremap <buffer> <leader>s :exec 'source '.expand('%:p')<CR>
