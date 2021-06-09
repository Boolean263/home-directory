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

# Shell history
export HISTCONTROL="ignorespace:ignoredups:erasedups"
export HISTSIZE=100000
export HISTFILESIZE=100000
shopt -s histreedit
shopt -s histappend

[ -f ~/.bash_aliases ] && . ~/.bash_aliases || :

# Custom Prompt {{{1

# Time the length a command took
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

# Semantic prompt areas (stolen from wezterm; see
# https://gitlab.freedesktop.org/Per_Bothner/specifications/blob/master/proposals/semantic-prompts.md
semantic_prompt() {
    printf '\e]133;%s;%s\a' "$1" "$2"
}
_SEM_PS1=`semantic_prompt P k=i`
_SEM_PS2=`semantic_prompt P k=c`
_SEM_INPUT=`semantic_prompt B`
_SEM_OUTPUT=`semantic_prompt C`
semantic_output() { echo -n "$_SEM_OUTPUT" ; }
semantic_errcode() { semantic_prompt D $code ; }

preexec_functions+=(semantic_output timer_start)
precmd_functions+=(save_errcode timer_stop semantic_errcode)

my_prompt()
{
    local -a PS

    # Tell terminal that this is the start of the prompt
    PS+=('\[$_SEM_PS1')

    # Reset any character sets or whatever, and clear the first line
    PS+=($(tput rmacs))
    PS+=('$(tput setab $(($HISTCMD % 2 ? 29 : 32)))')
    PS+=($(tput setaf 252)$(tput el)'\]')

    # Add time
    PS+=('$timer_show')

    # Add error if any
    PS+=('`echo "${code:+\['$(tput setaf 9)'\]\a⚠ $code }"`')

    # Add chroot if any
    PS+=('${debian_chroot:+"\['$(tput setaf 231)'\]$debian_chroot:"}')

    # Add working direvtory
    PS+=('\['$(tput setaf 252)'\]📂\w')

    # Add git prompt and end line
    PS+=('`__git_ps1`\['$(tput sgr0)'\]\n')

    # Give the hostname, command number, and actual prompt
    PS+=('\['$(tput setaf 2)'\]\h \!\$\['$(tput sgr0)'\] ')

    # Tell terminal that this is the start of the user input
    PS+=('\[$_SEM_INPUT\]')

    printf '%s' "${PS[@]}"
}
export PS1="$(my_prompt)"
unset -f my_prompt
export PS2="$_SEM_PS2$PS2$_SEM_INPUT"
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
