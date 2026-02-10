" Compatibility tweaks

" If running neovim under standard Windows, workaround broken tee
" https://github.com/neovim/neovim/issues/32504
if has('nvim') && &shell =~ 'cmd\.exe$' && ! executable('tee')
    let &shellpipe='2>&1 >_ && type _ && type _ > %s'
endif
