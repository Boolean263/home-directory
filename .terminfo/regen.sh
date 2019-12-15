#!/bin/sh

THISDIR="$(readlink -f "$0")"
THISDIR="${THISDIR%/*}"

export TERMINFO="$THISDIR"

for ti in $THISDIR/*.terminfo ; do
    tic -x $ti
done
