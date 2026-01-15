#!/bin/sh
# shellcheck disable=SC3043 # don't warn on `local` since most shells support it
#
# Helper functions for use in my various shell profile configs:
# .bashrc, .profile, etc.
# Can't be bash-specific.

### source_all_in()
# Source every file in the given directory matching the given name.
source_all_in()
{
    local FROM_DIR="${1:?no directory specified}"
    local FIND_GLOB="${2:-"*"}"
    local CONF_FILE

    if [ -d "$FROM_DIR" ] ; then
        set -a
        for CONF_FILE in $(find "$FROM_DIR" -maxdepth 1 -type f -name "$FIND_GLOB" \
                | sed 's/ /?/g' \
                | LC_COLLATE=POSIX sort)
        do
            # shellcheck disable=SC1090 # sourcing non-constant file -- no kidding!
            . "$CONF_FILE"
        done
        set +a
    fi
}
