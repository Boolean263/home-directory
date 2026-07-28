" Get most of my configuration from my vim settings
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vim/vimrc

" Add neovim-only lua configuration.
" Note that `require('foo.bar')` searches EVERY directory in runtimepath
" for the file `lua/foo/bar.lua` or then `lua/foo/bar/init.lua`.
" See :help lua-module-load for full details on what's happening.
" It's unclear to me how this interacts with plugins, but I think none of them
" are loaded at this point, even if my vimrc has added their paths
" to runtimepath.
"
" To reduce chances of namespace collisions, I've created
" $XDG_CONFIG_HOME/nvim/lua/user and plan to put all my own configs therein.
lua require('user')
