" This is a stub vimrc to force Windows as well as Linux
" to use my ~/.vim directory for configuration.

set runtimepath^=~/.vim     runtimepath+=~/.vim/after
set runtimepath-=~/vimfiles runtimepath-=~/vimfiles/after
if has('let')
    let &packpath = &runtimepath
endif
source ~/.vim/vimrc
