#!/bin/sh

# Tmux configuration that may be version-dependent goes here
# to keep my main .tmux.conf file from getting too messy.
# That's less frequent now that I'm only interested in 2.x versions of tmux,
# but this also is a handy place to do stuff using a slightly
# more powerful configuration language than tmux's own.

# This was once used in follow-on tests to choose version-specific syntax.
export TMUX_VERSION="$(tmux -V | grep -Eo '[0-9]+\.[0-9]+')"
tmux setenv -g TMUX_VERSION "$TMUX_VERSION"

# Use tmux's terminfo if we have it handy,
# otherwise fall back on screen's.
if infocmp tmux-256color >/dev/null ; then
    tmux set -g default-terminal tmux-256color
else
    tmux set -g default-terminal screen-256color
fi

# tmux needs to be told if its outer terminal has truecolour support.
# Rather than list them all I'll test the env var COLORTERM.
# (TMUX_ORIG_TERM is set in my tmux.conf)
if [ -n "$TMUX_ORIG_TERM" ] && [ -n "$COLORTERM" ] ; then
    tmux set -asq terminal-features ",$TMUX_ORIG_TERM:RGB"
    tmux set -asq terminal-overrides ",$TMUX_ORIG_TERM:Tc"
fi

# This isn't really version specific, it's just cool: per-server colours.
# defaults in case str2colour.py doesn't work
foreground=black
background=green
complement=brightyellow

str2colour.py $(hostname) | while read desc xcol col ; do
    # Temporarily set environment variables from
    # the str2colour output
    eval $desc=\'"$col"\'

    # If this is the last line of the str2colour output,
    # do our magic
    if ! [ "$desc" = "t2" ] ; then
        continue
    fi

    if vercmp.pl $TMUX_VERSION -lt 2.6 ; then
        tmux set -wg window-status-bg "$background"
        tmux set -wg window-status-fg "$foreground"
        tmux set -wg window-status-current-fg "$complement"
    else
        tmux set -g status-style "fg=$foreground,bg=$background"
        tmux set -g window-status-style "fg=$foreground,bg=$background"
        tmux set -g window-status-current-style "fg=$complement"
    fi
done
