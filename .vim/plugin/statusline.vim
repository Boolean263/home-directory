" Custom statusline
" http://got-ravings.blogspot.com/2008/08/vim-pr0n-making-statuslines-that-own.html

" Powerline glyphs
if !(exists('g:pl_r'))
    if has("gui_running") && has("win32unix")
        " My gvim in cygwin has an extra font loaded with other glyphs
        "let g:pl_r="" " U+E937
        "let g:pl_l="" " U+E938
        "let g:pl_r="▌" " U+258C left half block
        "let g:pl_l="▐" " U+2590 right half block
        " Looks like I have no good powerline fonts for cygwin gvim
        let g:pl_r=" "
        let g:pl_l=" "
        let g:pl_git="⌥" " U+2325, option key
    else
        let g:pl_r="" " U+E0B0, powerline symbol for filled in right-pointing triangle
        let g:pl_l="" " U+E0B2, powerline symbol for filled in left-pointing triangle
        let g:pl_git="" " U+E0A0, powerline symbol for git branch
    endif
endif

" Custom statusline colours
highlight User1 term=reverse ctermfg=0   ctermbg=208 guifg=#000000 guibg=#FF8700
highlight User2 term=reverse ctermfg=208 ctermbg=172 guifg=#FF8700 guibg=#D78700
highlight User3 term=reverse ctermfg=0   ctermbg=172 guifg=#000000 guibg=#D78700
highlight User4 term=reverse ctermfg=172 ctermbg=130 guifg=#D78700 guibg=#AF5F00
highlight User5 term=reverse ctermfg=0   ctermbg=130 guifg=#000000 guibg=#AF5F00

" Functions used in my statusline
function! SLFenc()
    if ! ( &fenc == "" || &fenc == "utf-8" ) || &bomb
        return "[" . &fenc . (&bomb ? "-bom" : "" ) . "]"
    else
        return ""
    endif
endfunction
function! SLGit()
    " Some logic copied from fugitive.vim
    if !(exists('g:loaded_fugitive') && exists('b:git_dir'))
        return ''
    endif
    let status = g:pl_git . fugitive#head(7)
    if fugitive#buffer().commit() != ''
        let status .= '(' . fugitive#buffer().commit() . ')'
    endif
    return status
endfunction
function! SLRarr()
    return g:pl_r
endfunction
function! SLLarr()
    return g:pl_l
endfunction
function! TagName()
    if !exists('tagbar#currenttag')
        return ''
    endif
    let l:tag_name = tagbar#currenttag("%s", "", "f")
    if l:tag_name != ""
        return '⇒'.l:tag_name
    else
        return ''
    endif
endfunction

" The statusline itself
set ruler               " Only really affects what Ctrl-G shows
set laststatus=2        " Always show status line
set statusline=         " Reset to blank
set statusline+=%1*     " colour to user1
set statusline+=%t      " Tail of the filename
set statusline+=%{&ro?'🔒':''} " U+1F512 Unicode lock for read-only flag
set statusline+=%{&mod?'+':''} " Plus sign for modified flag
set statusline+=%2*     " colour to user2
set statusline+=%{SLRarr()}
set statusline+=%3*     " colour to user3
set statusline+=%{SLGit()}
set statusline+=%4*     " colour to user4
set statusline+=%{SLRarr()}
set statusline+=%5*     " colour to user5
set statusline+=%{TagName()}
set statusline+=%=      " Left/Right separator
set statusline+=%{&ft}  " Another way of showing filetype
set statusline+=%{SLFenc()} " File encoding from above function
set statusline+=%4*     " colour to user4
set statusline+=%{SLLarr()}
set statusline+=%3*     " colour to user3
set statusline+=%5(%l:%c%)
set statusline+=%2*     " colour to user2
set statusline+=%{SLLarr()}
set statusline+=%1*     " colour to user1
set statusline+=%P      " Percent through file
set statusline+=/%L     " Number of lines in file

