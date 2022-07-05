" Folding management

" Better fold messages, from
" https://www.reddit.com/r/vim/comments/fwjpi4/here_is_how_to_retain_indent_level_on_folds/
function! NeatFoldText()
    let indent_level = indent(v:foldstart)
    let indent = repeat(' ',indent_level)
    let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
    let lines_count = v:foldend - v:foldstart + 1
    let lines_count_text = printf("%10s", lines_count . ' lines') . ' '
    let foldchar = matchstr(&fillchars, 'fold:\zs.')
    let foldtextstart = strpart(repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
    let foldtextend = lines_count_text . repeat(foldchar, 8)
    let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
    return indent . foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction
set foldtext=NeatFoldText()

" Better fold navigation, from
" https://vim.fandom.com/wiki/Navigate_to_the_next_open_fold
function! GoToOpenFold(direction)
    if (a:direction == "next")
        normal zj
        let start = line('.')
        while foldclosed(start) != -1
            let start = start + 1
        endwhile
    else
        normal zk
        let start = line('.')
        while foldclosed(start) != -1
            let start = start - 1
        endwhile
    endif
    call cursor(start, 0)
endfunction
"noremap <silent> ]z :call GoToOpenFold("next")<CR>
"noremap <silent> [z :call GoToOpenFold("prev")<CR>
noremap ]z zj
noremap [z zk
