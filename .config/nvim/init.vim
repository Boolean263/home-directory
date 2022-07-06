" Neovim GUIs seem to require a font set in this file, not in ginit.vim
set guifont=Iosevka\ Fixed\ Medium:h10

" Get most of my configuration from my vim settings
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vim/vimrc
