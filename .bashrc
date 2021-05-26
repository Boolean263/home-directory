# .bash_profile is called by bash when a LOGIN shell is started.
# .bashrc is called by bash when a NON-LOGIN shell is started.
#
# .profile and .bash_profile (which see) are intended for things that
# apply to the whole session, such as environment variables and some
# shell startup programs.
#
# .bashrc is for stuff that only applies to the shell itself.
#
# See https://superuser.com/a/183980

. "$HOME/env/path_functions.bash"

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

# Custom Prompt {{{1

save_errcode() {
    code=${?##0}
}
timer_start() {
    timer=$SECONDS
}
timer_stop() {
    [ -n "$timer" ] && timer_show=$(($SECONDS - $timer)) || timer_show=0
    unset timer
    if [ $timer_show -gt 0 ] ; then
        timer_show="⏳${timer_show}s "
    else
        timer_show=""
    fi
}
preexec_functions+=(timer_start)
precmd_functions+=(save_errcode timer_stop)

my_prompt()
{
    local -a PS

    # Reset any character sets or whatever, and clear the first line
    PS+=('\['$(tput rmacs))
    PS+=('$(tput setab $(($HISTCMD % 2 ? 29 : 32)))')
    PS+=($(tput setaf 252)$(tput el)'\]')

    # Add time
    PS+=('$timer_show')

    # Add error if any
    PS+=('`echo "${code:+\['$(tput setaf 9)'\]⚠ $code }"`')

    # Add chroot if any
    PS+=('${debian_chroot:+"\['$(tput setaf 231)'\]$debian_chroot:"}')

    # Add git prompt and end line
    PS+=('\['$(tput setaf 252)'\]\w`__git_ps1`\['$(tput sgr0)'\]\n')

    # Give the hostname, command number, and actual prompt
    PS+=('\['$(tput setaf 2)'\]\h \!\$\['$(tput sgr0)'\] ')

    printf '%s' "${PS[@]}"
}
export PS1="$(my_prompt)"
unset -f my_prompt
# }}}1

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
