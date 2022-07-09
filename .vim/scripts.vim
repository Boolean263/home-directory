" This file is for detecting filetypes by content.
" From `:help filetypedetect`, section D.
" If a filetype can be detected from its filename,
" use filetype.vim instead.

if did_filetype()
    finish
endif

" Use the `setfiletype` command to tell Vim to not change the
" filetype from what you've chosen here.
"if getline(1) =~ '^#!.*\<example\>'
"    setfiletype example
"endif
