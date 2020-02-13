#!/bin/sh

THISDIR=$(dirname $(readlink -f "$0"))

CONFIG_FILES=$(ls "$THISDIR"/*.ctags "$THISDIR"/*.ectags \
    | grep -Fv '.universal')

sed \
    -e '/^#/d' \
    -e '/^--extras\?-/d' \
    -e 's/^--extras=/--extra=/' \
    -e 's/^--\([A-Za-z0-9#+]\+\)-\(kinds\|regex\)=\(.*\)$/--\2-\1=\3/' \
    $CONFIG_FILES \
    > ~/.ctags
