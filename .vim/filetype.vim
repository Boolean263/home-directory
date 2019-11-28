if exists("did_load_filetypes")
    finish
endif
let did_load_filetypes_userafter=1
augroup filetypedetect
    " Use markdown syntax in vim, but let Windows recognize it as text
    au! BufNewFile,BufRead *.md.txt set filetype=markdown
augroup END
