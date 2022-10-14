nnoremap <buffer> <leader>n /^diff.*<CR>
nnoremap <buffer> <leader>N ?^diff.*<CR>
nnoremap <buffer> <leader>- /^-[^-]<CR>
nnoremap <buffer> <leader>+ /^+[^+]<CR>

" Borrowed from https://github.com/sgeb/vim-diff-fold/
" and its forks

setlocal nomodeline
setlocal foldmethod=expr
setlocal foldexpr=DiffFoldLevel()

" Get fold level for diff mode
" Works with normal, context, unified, rcs, ed, subversion and git diffs.
" For rcs diffs, folds only files (rcs has no hunks in the common sense)
" foldlevel=1 ==> file
" foldlevel=2 ==> hunk
" context diffs need special treatment, as hunks are defined
" via context (after '***************'); checking for '*** '
" or ('--- ') only does not work, as the file lines have the
" same marker.
" Inspired by Tim Chase.
function! DiffFoldLevel()
    let l:line=getline(v:lnum)

    if l:line =~# '^\-- \s*'
        return '>0'
    elseif l:line =~# '^\(diff\|Index\|-- \)'     " file
        return '>1'
    elseif l:line =~# '^\(@@\|\d\)'  " hunk
        return '>2'
    elseif l:line =~# '^\*\*\* \d\+,\d\+ \*\*\*\*$' " context: file1
        return '>2'
    elseif l:line =~# '^--- \d\+,\d\+ ----$'     " context: file2
        return '>2'
    elseif l:line =~# '^Only in' " file only in one folder when using diff -r
        return '>1'
    else
        return '='
    endif
endfunction

if exists('g:sectional_couch')
    setlocal paragraphs=/^@@/
    setlocal sections=/^diff/
endif

" Use vim-textobj-user to allow using the 'h' object to select/navigate
" hunks within a diff/patch file
call textobj#user#plugin('diff', {
\   'hunk': {
\       'select-a-function': 'DiffSelect',
\       'select-i-function': 'DiffSelect',
\       'region-type': 'V',
\       'select-a': [],
\       'select-i': [],
\       'move-n': [],
\       'move-p': [],
\   }
\ })
augroup diff_textobjs
    autocmd!
    autocmd FileType diff call textobj#user#map('diff', {
\       'hunk': {
\           'select-a': 'ah',
\           'select-i': 'ih',
\           'move-n': ']h',
\           'move-p': '[h',
\       }
\ })
augroup END
function! DiffSelect()
    let l:line = getline('.')
    if l:line =~ '^[^+-]'
        return 0
    endif
    return ['V',
            \ [ 0, search('^[^+-]', 'nWb')+1, 1, 0 ],
            \ [ 0, search('^[^+-]', 'nW')-1, 1, 0 ]
            \ ]
endfunction

" Strip leading [+- ] from yanked linewise diffs
augroup YankDiffs
    autocmd!
    autocmd TextYankPost <buffer> call DiffCleansePatch(v:event)
augroup END
function! DiffCleansePatch(evt)
    " Only useful if we've been called on a linewise yank/delete
    if a:evt.regtype !=# 'V'
        return
    endif
    let nr = []
    for ln in a:evt.regcontents
        let nr += [ ln[1:] ]
    endfor
    call setreg(a:evt.regname, nr)
endfunction

let b:undo_ftplugin .= " | setlocal modeline< foldmethod< foldexpr<"
    \ . " paragraphs< sections<"
    \ . " |silent! nunmap <buffer> <leader>n"
    \ . " |silent! nunmap <buffer> <leader>N"
    \ . " |silent! nunmap <buffer> <leader>-"
    \ . " |silent! nunmap <buffer> <leader>+"
