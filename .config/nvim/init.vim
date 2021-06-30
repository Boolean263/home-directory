" The neovide GUI requires a font set in this file
set guifont=Iosevka\ Fixed\ Medium:h11

" Get most of my configuration from my vim settings
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vim/vimrc
