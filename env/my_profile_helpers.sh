#!/bin/bash
# shellcheck disable=SC3043 # don't warn on `local` since most shells support it
#
# Helper functions for use in my various shell profile configs:
# .bashrc, .profile, etc.

### source_all_in()
# Source every file in the given directory matching the given find(1) criteria.
# Example: source_all_in ~/.config/profile.d -name '*.sh'
# Note: dependent on bash for `read -rd ''` and `< <(cmd)`,
# and GNU sort(1) for its `-z` option
source_all_in()
{
    local FROM_DIR="${1:?no directory specified}"
    shift
    local CONF_FILE
    #echo "source_all_in start $FROM_DIR $*" 1>&2

    if [ -d "$FROM_DIR" ] ; then
        set -a
        while read -rd '' CONF_FILE; do
            #echo "source_all_in $CONF_FILE" 1>&2
            # shellcheck disable=SC1090 # sourcing non-constant file -- no kidding!
            . "$CONF_FILE"
        done < <(find "$FROM_DIR" -maxdepth 1 \
                    -type f ${1:+"$@"} -print0 \
                    | LC_COLLATE=POSIX sort -z)
        set +a
    fi
    #echo "source_all_in end $FROM_DIR" 1>&2
}
