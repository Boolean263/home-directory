
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set ruler

set scrolloff=10

set pastetoggle=<F9>

set fileencodings=ucs-bom,utf-8,latin1

set list listchars=tab:>·,trail:·,extends:>

if (&term == 'xterm' || &term =~? '^screen')
    set t_Co=256
endif

set background=dark
"colorscheme desert256
"colorscheme asu1dark
"colorscheme solarized

perl use Vim::X;
perl Vim::X::source_function_dir("~/.vim/perl");
