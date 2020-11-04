#!/bin/sh

if [ -n "$1" ] ; then
    gdb -p $1 -x "$HOME/etc/silence.gdb"
else
    echo "Usage: $0 <PID>" 1>&2
    exit 1
fi
