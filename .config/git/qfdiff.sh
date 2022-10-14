#!/bin/sh
#
# This is meant to be used as an external diff driver for git,
# one which generates file names and line numbers in a format that
# can be used by vim's quickfix mode (hence the 'qf' prefix).
#
# The standard way to use it as a diff driver is like so:
#   GIT_EXTERNAL_DIFF=<this script> git diff ...
#
# My alternate approach is to call it as a difftool instead:
#   git difftool --tool=qfdiff ...
# See my ~/.config/git/config for details on how I set this up.

case $# in
    1)
        echo "Unmerged file $@, can't show you line numbers" 1>&2
        exit 1
        ;;
    3)
        # Called via difftool
        path="$1"
        remote="$2"
        local="$3"
        if [ "$local" = "/dev/null" ] ; then
            old_file="$local"
            new_file="$path"
        else
            old_file="$path"
            new_file="$local"
        fi
        ;;
    7)
        # Called via diff driver
        path="$1"
        old_file="$2"
        old_hex="$3"
        old_mode="$4"
        new_file="$5"
        new_hex="$6"
        new_mode="$7"
        ;;
    *)
        echo "I don't know what to do with: $@" 1>&2
        exit 1
        ;;
esac

/usr/bin/diff "$old_file" "$new_file" | /usr/bin/grep -v '^[<>-]' | \
    while read line ; do
        printf '%s' "$path"
        echo "$line" | /usr/bin/sed -E 's/^([0-9]+)([^0-9].*)$/\1: \1\2/'
    done
