" Settings meant to adhere to PEP-8

setlocal expandtab                  " PEP-8 recommends spaces
setlocal tabstop=4
setlocal shiftwidth=0               " use tabstop
setlocal softtabstop=-1             " use shiftwidth (which uses tabstops)
setlocal textwidth=88               " used by black

augroup pyblack
    autocmd!
    autocmd BufWritePre *.py execute ':Black'
augroup END

let b:undo_ftplugin .= " |setlocal expandtab< tabstop< shiftwidth< softtabstop< textwidth< |augroup! pyblack"
