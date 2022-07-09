" This file is for detecting filetypes by filename.
" From `:help filetypedetect`, section C.
" If a filetype can only be detected by inspecting its content,
" use scripts.vim instead.
if exists("did_load_filetypes")
    finish
endif
let did_load_filetypes_userafter=1

augroup filetypedetect
    " Use the `setfiletype` command to tell Vim to not change the
    " filetype from what you've chosen here.

    " Use markdown syntax in vim, but let Windows recognize it as text
    au! BufNewFile,BufRead *.md.txt setfiletype markdown
augroup END
