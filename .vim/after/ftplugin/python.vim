" Settings meant to adhere to PEP-8

setlocal expandtab                  " PEP-8 recommends spaces
setlocal tabstop=4
setlocal shiftwidth=0               " use tabstop
setlocal softtabstop=-1             " use shiftwidth (which uses tabstops)
setlocal textwidth=88               " used by black

let b:undo_ftplugin .= " |setlocal expandtab< tabstop< shiftwidth< softtabstop< textwidth<"

function! s:pre_write_python()
    if ! exists('b:no_black')
        execute ':Black'
    endif
endfunction

if exists(':Black')
    augroup pyblack
        autocmd!
        autocmd BufWritePre *.py call s:pre_write_python()
    augroup END
    let b:undo_ftplugin .= "|augroup! pyblack"
end

