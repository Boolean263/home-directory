#!/bin/sh

: ${TMUX_VERSION:?TMUX_VERSION not set}

# Tmux configuration that may be version-dependent goes here
# to keep my main .tmux.conf file from getting too messy.
# (That's less frequent now that I'm only interested in 2.x versions)

# tmux needs to be told about terminals that have truecolour support.
# Rather than list them all I'll test the env var COLORTERM
if [ "$COLORTERM" = "truecolor" ] ; then
    tmux set -asq terminal-features ",$TERM:RGB"
    tmux set -asq terminal-overrides ",$TERM:Tc"
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

