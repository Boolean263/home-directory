#!/bin/sh
# shellcheck disable=SC3043 # don't warn on `local` since most shells support it
#
# Helper functions for use in my various shell profile configs:
# .bashrc, .profile, etc.
# Can't be bash-specific.

### source_all_in()
# Source every file in the given directory matching the given find(1) criteria.
# Example: source_all_in ~/.config/profile.d -name '*.sh'
# Note: File read order doesn't seem to be guaranteed, despite using sort(1)
# on the results.
source_all_in()
{
    local FROM_DIR="${1:?no directory specified}"
    shift
    local CONF_FILE
    #local SAIDEBUG=1

    if [ -d "$FROM_DIR" ] ; then
        [ -n "{$SAIDEBUG:-}" ] && echo "source_all_in start: $FROM_DIR" 1>&2
        # Separating on nulls gives weird errors and doesn't work.
        # We've tried using another delimiter instead...
        #
        #   local SaveIFS="$IFS"
        #   local IFS
        #   IFS="$(printf '\x1E')" # Record Separator; octal 036
        #   find ... -printf '%h/%f\036'
        #   IFS="$SaveIFS" . "$CONF_FILE"
        #
        # ...but it seems to mess up the file read/sort order.
        # So instead we just replace spaces with '?' and hope
        # globbing is enough from there.

        set -a
        for CONF_FILE in $(find "$FROM_DIR" -maxdepth 1 \
                -type f ${1:+"$@"} -print \
            | sed 's/ /?/g' \
            | LC_COLLATE=POSIX sort)
        do
            [ -n "{$SAIDEBUG:-}" ] && echo "source_all_in: $CONF_FILE" 1>&2
            # shellcheck disable=SC1090 # sourcing non-constant file -- no kidding!
            . "$CONF_FILE"
        done
        set +a
        [ -n "{$SAIDEBUG:-}" ] && echo "source_all_in end: $FROM_DIR" 1>&2
    else
        [ -n "{$SAIDEBUG:-}" ] && echo "source_all_in nonexistent dir: $FROM_DIR" 1>&2
    fi
}
