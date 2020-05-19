#!/bin/sh

if [ -z "$1" ] ; then
    cat 1>&2 <<EOT
This is a wrapper for running a command from X
and showing problems as a desktop notification.
Useful when not using a terminal to see the results.

Usage:
    $0 <command>
EOT
    exit 1
fi

"$@"
status="$?"
case "$status" in
    0) exit ;;
    127) msg="Command not found: $*" ;;
    *) msg="Status $status: $*" ;;
esac
notify-send -i error "$1 failed ($status)" "$msg"
