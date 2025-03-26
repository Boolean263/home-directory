#!/bin/sh

THISDIR=$(dirname $(readlink -f "$0"))
OUTFILE="$HOME/.ctags"

# Naming convention:
#   *.ctags are okay for both types of ctags
#   *.universal.ctags are only for universal-ctags
#   *.ectags are only for exuberant-ctags (and kept here for consistency)

# Make sure we can write to the file
if [ -f "$OUTFILE" ] ; then
    chmod u+w "$OUTFILE"
fi

CONFIG_FILES=$(LC_ALL=C command ls "$THISDIR"/*.ctags "$THISDIR"/*.ectags \
    | grep -Fv '.universal.ctags')

# Remove the stuff that exuberant-ctags can't handle
sed \
    -e '/^#/d' \
    -e '/^--extras\?-/d' \
    -e 's/^--extras=/--extra=/' \
    -e 's/^--\([A-Za-z0-9#+]\+\)-\(kinds\|regex\)=\(.*\)$/--\2-\1=\3/' \
    $CONFIG_FILES \
    > "$OUTFILE"

# Try to warn ourselves that we shouldn't edit the file manually
# (since we can't put a comment in it to do so)
chmod a-w "$OUTFILE"
