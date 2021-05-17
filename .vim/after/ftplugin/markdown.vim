runtime! ftplugin/text.vim

if exists('*Tablify')
     inoremap <silent> <Bar> <Bar><C-O>:call Tablify('<Bar>')<CR>
endif
