syntax on
set synmaxcol=999

" Handle the proper colour depth if possible
if &term == 'builtin_gui'
    " Do nothing, it handles itself
elseif $COLORTERM =~ 'truecolor' || $COLORTERM =~ '24bit'
    if has('termguicolors')
        set termguicolors
        "if &term =~ '^st'
            " slight bug?
            "let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
            "let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
        "endif
    endif
"elseif &term =~ '-256color'
    "set t_Co=256
endif

" Some themes like gruvbox need their customizations made before you
" activate them
let g:gruvbox_italic=1
let g:gruvbox_contrast_dark="hard"
let g:gruvbox_contrast_light="hard"

"let g:monotone=[10, 25, 80]
let g:monotone_color = [120, 100, 70] " Sets theme color to bright green
let g:monotone_secondary_hue_offset = 200 " Offset secondary colors by 200 degrees

set background=dark
"colorscheme desert256
"colorscheme asu1dark
"colorscheme solarized
"colorscheme apprentice
"colorscheme base16-eighties
"colorscheme koehler
"colorscheme dracula
"colorscheme gruvbox
"colorscheme monotone
colorscheme plain

" Set colour customizations *after* setting colorscheme.
if ! exists('g:colors_name')
    " Something went wrong loading the colorscheme. Have this block
    " to prevent further errors.
elseif g:colors_name == 'dracula'
    "highlight CursorLine   term=none cterm=none ctermbg=238 guibg=#222222
    "highlight CursorLine NONE
    highlight CursorLine   term=underline cterm=underline ctermbg=NONE guibg=NONE gui=undercurl
    highlight CursorColumn term=none cterm=none ctermbg=238 guibg=#222222
    highlight ColorColumn  term=none cterm=none ctermbg=235 guibg=#0F0F0F
    highlight LineNr       term=underline cterm=none ctermfg=3 ctermbg=0 guifg=Yellow guibg=Black
    highlight CursorLineNr term=inverse cterm=none ctermfg=0 ctermbg=11 guifg=#000000 guibg=#FFFF00
    " CursorLineNr applies to the current line number only if relativenumber
    " is set, or if number AND cursorline are both set. cursorline and
    " relativenumber both slow vim down. Hopefully, "highlight CursorLine NONE"
    " mitigates that somewhat.

    "highlight DiffDelete   term=none cterm=none ctermfg=0 ctermbg=52 guifg=black guibg=#5F0000
    "highlight DiffAdd      term=none cterm=none ctermbg=22 guibg=#005F00
    "highlight DiffChange   term=none cterm=none ctermbg=17 guibg=#00005F
    "highlight DiffText     term=underline cterm=underline ctermbg=20 guibg=#0000D7
elseif g:colors_name == 'plain'
    highlight Normal ctermfg=251 ctermbg=0 guifg=#CCCCCC guibg=#222222
    highlight clear SignColumn
    highlight SignColumn term=none cterm=none ctermbg=black guibg=black
    highlight clear GitGutterAdd
    highlight clear GitGutterDelete
    highlight clear GitGutterChange
    highlight clear GitGutterChangeDelete
    highlight GitGutterAdd term=standout ctermfg=green guifg=green guibg=black
    highlight GitGutterChange term=standout ctermfg=yellow guifg=yellow guibg=black
    highlight GitGutterDelete term=standout ctermfg=red guifg=red guibg=black 
    highlight link GitGutterChangeDelete GitGutterChange

    highlight clear CursorColumn
    highlight link CursorColumn CursorLine

    highlight Pmenu guibg=#000000 ctermbg=0 term=standout
endif
