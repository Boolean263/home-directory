" Delete temporary vlessXXXXXXXX files on close

augroup vless
    autocmd!
    autocmd BufUnload vless[A-Za-z0-9_]\+ call delete(expand("<afile>"))
augroup END
