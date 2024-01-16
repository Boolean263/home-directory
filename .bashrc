#!/bin/bash
# ~/.bashrc: sourced by bash for non-login interactive shells
# (and, thanks to my .bash_profile, for login interactive shells too).
# This is the place to put things that apply to the interactive shell
# itself: aliases, functions, shell options, etc.
# (Source: <https://superuser.com/a/183980/627623>)

. "$HOME/env/path_functions.sh"
set match-hidden-files off

# Nothing after this will run for non-interactive shells
case "$-" in
    *i*) ;;
    *) return ;;
esac

. "$HOME/env/git-prompt.sh"
. "$HOME/env/bash-preexec.sh"

# If this is a remote host being ssh'd into, launch tmux or screen if we can
if [ -n "$SSH_CONNECTION" ] && ! [ -e "$HOME/.no-tmux" ] ; then
    # Protect against nested sessions
    if [ -z "$TMUX" ] && [ -z "$STY" ] ; then
        # Move ssh auth sock to a consistent location
        SOCK="$HOME/.ssh/auth_sock/$(hostname)"
        mkdir -p "$HOME/.ssh/auth_sock"
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

shopt -s direxpand

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
export BASH_COMPLETION_USER_FILE="$XDG_CONFIG_HOME/bash/bash_completion"
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Shell history
shopt -s histreedit histappend checkwinsize cmdhist direxpand
mkdir -p "$XDG_STATE_HOME/bash"
export HISTFILE="$XDG_STATE_HOME/bash/history"
export HISTCONTROL="ignorespace:ignoredups:erasedups"
export HISTSIZE=100000
export HISTFILESIZE=1000000
export HISTIGNORE="gits:ls:ll:m:pwd"
export HISTTIMEFORMAT="%Y-%m-%dT%H:%M:%S%Z "

. "$XDG_CONFIG_HOME/bash/bash_aliases"

# Custom Prompt {{{1

# Time the length a command took
save_errcode() {
    code=${?##0}
}
#timer_start() {
#    timer=$SECONDS
#}
#timer_stop() {
#    [ -n "$timer" ] && timer_show=$(($SECONDS - $timer)) || timer_show=0
#    unset timer
#    if [ $timer_show -gt 0 ] ; then
#        timer_show="⏳${timer_show}s "
#    else
#        timer_show=""
#    fi
#}

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

preexec_functions+=(semantic_output)
precmd_functions+=(save_errcode semantic_errcode)

my_prompt()
{
    local -a PS
    local SGR0=$(tput sgr0)

    # Tell terminal that this is the start of the prompt
    PS+=('\[$_SEM_PS1')

    # Set colours I like
    local background=29
    local foreground=252
    local complement=9
    local t1=231
    local t2=231

    # Get per-host colours if I can
    if which str2colour.py > /dev/null 2>&1 ; then
        local allcolours=$(str2colour.py -d $HOSTNAME)
        while read varname cnum rgb ; do
            [ -n "$varname" ] || continue
            eval "$varname=$cnum"
        done <<< "$allcolours"
    fi

    # Reset any character sets or whatever, and clear the first line
    PS+=($(tput rmacs))
    PS+=($(tput setab $background))
    PS+=($(tput setaf $foreground)$(tput el)'\]')

    # Add time
    #PS+=('$timer_show')

    # Add error if any
    PS+=('`echo "${code:+\['$(tput setaf 9)'\]\a⚠ $code }"`')

    # Add hostname
    PS+=("\[$(tput setaf complement)\]$HOSTNAME")

    # Add chroot if any
    PS+=('${debian_chroot:+"\['$(tput setaf $t1)'\]:$debian_chroot"}')

    # Add working directory
    PS+=(' \['$(tput setaf $foreground)'\]📂\w')

    # Add git prompt and end line
    PS+=('\['$(tput setaf $t2)'\]`__git_ps1 " %s"`')
    PS+=("\[$SGR0\]")
    PS+=($'\n')

    # Give the hostname, command number, and actual prompt
    PS+=('\['$(tput sgr0)'\]\!\$ ')

    # Tell terminal that this is the start of the user input
    PS+=('\[$_SEM_INPUT\]')

    printf '%s' "${PS[@]}"
}
export PS1="$(my_prompt)"
unset -f my_prompt
export PS2="$_SEM_PS2$PS2$_SEM_INPUT"
# }}}1

if [ "$LESSKEYIN" -nt "$LESSKEY" ] ; then
    lesskey -o "$LESSKEY" -- "$LESSKEYIN"
fi

# Try out vi command mode for grins
set -o vi

# Don't know why I need this
bind -f "$INPUTRC"

# Terminal setup
/bin/stty stop undef start undef erase ^? werase ^H

if [ -f "$HOME/.bashrc.local" ] ; then
    . "$HOME/.bashrc.local"
fi

# vim:set foldmethod=marker:
