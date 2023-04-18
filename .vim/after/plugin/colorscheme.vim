" This file covers some of my basic colorscheme preferences.
" As per ':help :colorscheme', my per-scheme customizations
" are in ~/.vim/colors .
syntax on
set synmaxcol=200

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


set background=dark
colorscheme myplain

" Set colour customizations *after* setting colorscheme.
if ! exists('g:colors_name')
    " Something went wrong loading the colorscheme. Have this block
    " to prevent further errors.
    " Use a default colorscheme.
    colorscheme darkblue
endif
