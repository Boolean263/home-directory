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

# If this is a remote host being ssh'd into, launch tmux or screen if we can
if [ -n "$SSH_CONNECTION" ] && ! [ -e "$HOME/.no-tmux" ] ; then
    # Protect against nested sessions
    if [ -z "$TMUX" ] && [ -z "$STY" ] ; then
        SOCK="$HOME/.ssh/auth_sock/$(hostname)"
        if [ -n "$SSH_AUTH_SOCK" ] && [ "$SSH_AUTH_SOCK" != "$SOCK" ] ; then
            rm -f "$SOCK"
            ln -sf "$SSH_AUTH_SOCK" "$SOCK"
            export SSH_AUTH_SOCK="$SOCK"
        fi
        if $(which tmux >/dev/null 2>&1) ; then
            exec sh -c 'tmux attach-session -t ssh || exec tmux new-session -s ssh'
        elif $(which screen >/dev/null 2>&1) ; then
            exec screen -S ssh -x -RR
        fi
    fi
fi

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

[ -f ~/.profile ] && . ~/.profile || :

# User specific environment and startup programs.
# For the custom prompt, use care with $(...) executions that are within
# the quotes, since they're evaluated at prompt showing time -- and may
# stomp on $? and the like. (This is why I don't call __git_ps1 until
# after I've added $? to the prompt.)
# Use tput instead of hard-coded escape sequences. Some with math
# I evaluate once here.... well, kinda. You'll see.
tBG=$(tput setab 99 | sed 's/99/$((HISTCMD % 2 ? 29 : 32))/')
tERR=$(tput setaf 99 | sed 's/99/$(( $? > 0 ? 9 : 7 ))/')
export PS1='\['$(tput rmacs)$tBG$(tput setaf 7)$(tput el)'\][\['$tERR'\]?:$?\['$(tput setaf 231)'\]${debian_chroot:+" $debian_chroot:"}\['$(tput setaf 7)'\]] \w$(__git_ps1)\['$(tput sgr0)'\]\n\['$(tput setaf 2)'\]\h \!\$\['$(tput sgr0)'\] '
unset tBG tERR

if [ -f "$HOME/.lesskey" ] && [ "$HOME/.lesskey" -nt "$HOME/.less" ] ; then
    lesskey
fi

# Try out vi command mode for grins
set -o vi

# Don't know why I need this
bind -f "$INPUTRC"

# Terminal setup
/bin/stty stop undef start undef erase ^? werase ^H

[ -f "$HOME/.bashrc.local" ] && . "$HOME/.bashrc.local" || true
