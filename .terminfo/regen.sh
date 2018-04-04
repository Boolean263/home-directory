#!/bin/sh

THISDIR="$(readlink -f "$0")"
THISDIR="${THISDIR%/*}"

export TERMINFO="$THISDIR"

tic -x "$TERMINFO"/*.terminfo
