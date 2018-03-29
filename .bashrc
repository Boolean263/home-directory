# .bash_profile is called by bash when a LOGIN shell is started.
# .bashrc is called by bash when a NON-LOGIN shell is started.
# I want my .profile and such called always, so even my bash-specific
# environment settings are in .profile, and .bash_profile is just a
# call to .bashrc.

is_interactive(){
    [ -n "$PS1" ]
}

# Anything after this case will not be done in non-interactive shells
case $- in
    *i*) ;;
    *) return;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

. "$HOME/env/git-prompt.sh"

set match-hidden-files off

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

[ -f ~/.profile ] && . ~/.profile

# User specific environment and startup programs
if [ "$TERM" = "linux" ] ; then
    export PS1="\[\e[0;32m\][?:\$? \w] \$(parse_git_branch)\n\!\\$\[\e[0m\] "
else
    #export PS1='\[e[0;48;5;$((233+((\#%2)*2)))m\e[38;5;7m\e[K\e[32m\][?:$? \w]\n\!\$\[\e[38;5;15m\] '
    export PS1='\[\e[0;48;5;$((29+((\#%2)*3)))m\e[38;5;7m\e[K\e[30m\][?:$? \w] $(__git_ps1)\[\e[0m\]\n\[\e[0;32m\]\!\$\[\e[0m\] '
fi

if [ -f "$HOME/.lesskey" ] && [ "$HOME/.lesskey" -nt "$HOME/.less" ] ; then
    lesskey
fi


# Don't know why I need this
bind -f "$INPUTRC"

# Terminal setup
/bin/stty stop undef start undef erase ^? werase ^_

[ -f "$HOME/.bashrc.local" ] && . .bashrc.local || true
