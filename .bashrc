# .bash_profile is called by bash when a LOGIN shell is started.
# .bashrc is called by bash when a NON-LOGIN shell is started.
# I want my .profile and such called always, so even my bash-specific
# environment settings are in .profile, and .bash_profile is just a
# call to .bashrc.
# (Technically that's not how it should be done; see
# https://superuser.com/a/183980 and come back to this decision.)

[ -f ~/.profile ] && . ~/.profile || :

is_interactive(){
    [ -n "$PS1" ]
}

# Anything after this case will not be done in non-interactive shells
case $- in
    *i*) ;;
    *) return;
esac

. "$HOME/env/git-prompt.sh"
. "$HOME/env/bash-preexec.sh"
# bash-preexec.sh seems cool. See also PROMPT_COMMAND (built in to bash)

# If this is a remote host being ssh'd into, launch tmux or screen if we can
if [ -n "$SSH_CONNECTION" ] && ! [ -e "$HOME/.no-tmux" ] ; then
    # Protect against nested sessions
    if [ -z "$TMUX" ] && [ -z "$STY" ] ; then
        # Move ssh auth sock to a consistent location
        SOCK="$HOME/.ssh/auth_sock/$(hostname)"
        if [ -n "$SSH_AUTH_SOCK" ] && [ "$SSH_AUTH_SOCK" != "$SOCK" ] ; then
            rm -f "$SOCK"
            ln -sf "$SSH_AUTH_SOCK" "$SOCK"
            export SSH_AUTH_SOCK="$SOCK"
        fi
        ~/bin/tn ssh && exit 0
    fi
fi
if [ -n "$TMUX" ] ; then
    # We're inside a tmux session.
    # Define a bash function to fix DISPLAY and other important variables
    tfixenv() {
        . <(tmux show-env | sed -e '/^-/d' -e "s/=\(.*\)$/='\1'/")
    }
    # And have it called before each command
    preexec_functions+=(tfixenv)
fi

set match-hidden-files off

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

shopt -s histreedit

[ -f ~/.bash_aliases ] && . ~/.bash_aliases || :

# User specific environment and startup programs.
# For the custom prompt, use care with $(...) executions that are within
# the quotes, since they're evaluated at prompt showing time -- and may
# stomp on $? and the like. (This is why I don't call __git_ps1 until
# after I've added $? to the prompt.)
# Use tput instead of hard-coded escape sequences. Some with math
# I evaluate once here.... well, kinda. You'll see.
tBG=$(tput setab 99 | sed 's/99/$((HISTCMD % 2 ? 29 : 32))/')
export PS1='\['$(tput rmacs)$tBG$(tput setaf 7)$(tput el)'\]`code=${?##0}; echo "${code:+\['$(tput setaf 9)'\]E$code }"`\['$(tput setaf 231)'\]${debian_chroot:+" $debian_chroot:"}\['$(tput setaf 7)'\]\w`__git_ps1`\['$(tput sgr0)'\]\n\['$(tput setaf 2)'\]\h \!\$\['$(tput sgr0)'\] '
unset tBG

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
