" http://vim.wikia.com/wiki/Setting_file_attributes_without_reloading_a_buffer
if has('win32')
    finish
endif
function s:SetExecutableBit()
    if &shell =~ 'sh$'
        let fname = expand("%:p")
        checktime
        if ! &autoread
            execute "au FileChangedShell " . fname . " :echo"
        endif
        silent !chmod a+x %
        checktime
        if ! &autoread
            execute "au! FileChangedShell " . fname
        endif
    endif
endfunction
nnoremap <Plug>Xbit :<C-U>call <SID>SetExecutableBit()<CR>
