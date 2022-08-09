" lightline.vim
set ruler
set laststatus=2
set noshowmode

let g:lightline = {
            \ 'colorscheme': 'PaperColor',
            \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
            \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
            \ 'mode_map': {
            \   'n': 'NOR',
            \   'i': 'INS',
            \   'R': 'OVR',
            \   'v': 'VIS',
            \   'V': 'V-L',
            \   '\<C-v>': 'V-B',
            \   'c': 'CMD',
            \   's': 'SEL',
            \   'S': 'S-L',
            \   '\<C-s>': 'S-BL',
            \   't': 'TER',
            \ },
            \ 'active': {
            \   'left': [
            \       ['mode', 'paste'],
            \       ['filename', 'gitbranch'],
            \       ['functag'],
            \   ],
            \   'right': [
            \       ['lineno'],
            \       ['line_column'],
            \       ['fileencoding', 'filetype'],
            \   ],
            \ },
            \ 'inactive': {
            \   'left': [
            \       ['filename', 'gitbranch'],
            \       ['functag'],
            \   ],
            \   'right': [
            \       ['lineno'],
            \       ['line_column'],
            \   ],
            \ },
            \ 'tabline': {
            \   'left': [
            \       ['tabs'],
            \   ],
            \   'right': [
            \       ['close'],
            \   ],
            \ },
            \ 'component': {
            \   'lineno': '%P/%L',
            \   'line_column': '%l:%c',
            \ },
            \ 'component_function': {
            \   'filename': 'LightlineFilename',
            \   'fileencoding': 'LightlineFileenc',
            \   'gitbranch': 'LightlineGitbranch',
            \   'functag': 'LightlineTag',
            \ },
\ }

" I've set these above to the Powerline glyphs.
" Here I'm using the more standard box-drawing glyphs.
let g:lightline.separator = { 'left': "\u258c", 'right': "\u2590" }
let g:lightline.subseparator = { 'left': "\u2502", 'right': "\u2502" }

function! LightlineFilename()
    let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
    let modified = &modified ? '+' : ''
    let myro = &readonly && &filetype !=# 'help' ? 'X' : ''
    if &filetype == 'qf'
        let filename = 'quickfix'
    endif
    return filename . modified . myro
endfunction

function! LightlineFileenc()
    if ! ( &fenc == "" || &fenc == "utf-8" ) || &bomb
        return &fenc . (&bomb ? '-bom' : '')
    endif
    return ""
endfunction

function! LightlineGitbranch()
    if exists('*FugitiveHead')
        let l:head = FugitiveHead()
        return l:head !=# '' ? "\ue0a0".l:head : ''
    endif
    return ''
endfunction

function! LightlineTag()
    if !(exists(':Tagbar'))
        return ""
    endif
    let l:tag_name = tagbar#currenttag("%s", "", "f")
    if l:tag_name != ""
        return '⇒ '.l:tag_name
    else
        return ''
    endif
endfunction
