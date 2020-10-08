#!/bin/sh
#
# Script to ensure xscreensaver gets launched, but only if it's not already
# running. Also start things like xssproxy.

which xscreensaver >/dev/null || exit 1
which xscreensaver-command >/dev/null || exit 1

# This is the 'magic' part
xscreensaver-command -version >/dev/null 2>&1 || \
    xscreensaver -no-splash &

if which xssproxy >/dev/null 2>&1 && ! pgrep xssproxy >/dev/null ; then
    xssproxy &
fi
