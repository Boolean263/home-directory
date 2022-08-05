# Initialization script for ksh, based on my .bashrc.
# As with that file, this file is only read by ksh for interactive shells.

# This is needed to allow bash function definitions to work in ksh.
# Even then it only really works with `function foo`-style definitions,
# not `foo()`-style.
alias local=typeset

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
        ~/bin/tn ssh && exit 0
    fi
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.ksh_aliases, instead of adding them here directly.
# (Or .bash_aliases, the syntax of which seems to work fine for ksh too.)
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# User specific environment and startup programs.
. <("$HOME/bash2ksh.sed" "$HOME/env/git-prompt.sh")

# The custom prompt is surprisingly similar to what I can do in bash.
# The main difference is there are no backslash-escapes so you need to
# use $(command expansion) instead of eg. \w.
# For the custom prompt, use care with $(...) executions that are within
# the quotes, since they're evaluated at prompt showing time -- and may
# stomp on $? and the like. (This is why I don't call __git_ps1 until
# after I've added $? to the prompt.)
# Use tput instead of hard-coded escape sequences. Some with math
# I evaluate once here.... well, kinda. You'll see.
tBG=$(tput setab 99 | sed 's/99/$((HISTCMD % 2 ? 29 : 32))/')
tERR=$(tput setaf 99 | sed 's/99/$(( $? > 0 ? 9 : 7 ))/')
export PS1=$(tput rmacs)$tBG$(tput setaf 7)$(tput el)'['$tERR'?:$?'$(tput setaf 231)'${debian_chroot:+" $debian_chroot:"}'$(tput setaf 7)$'] $(pwd | sed -e "s\x1F^$HOME\x1F~\x1F" -e "s/!/!!/g")$(__git_ps1)'$(tput sgr0)$'\n'$(tput setaf 2)$(hostname -s)' !$'$(tput sgr0)' '
unset tBG tERR

if [ -f "$HOME/.lesskey" ] && [ "$HOME/.lesskey" -nt "$HOME/.less" ] ; then
    lesskey
fi

# Try out vi command mode for grins
set -o vi

# Terminal setup
/bin/stty stop undef start undef erase ^? werase ^H

if [ -f "$HOME/.kshrc.local" ] ; then
    . "$HOME/.kshrc.local"
fi
