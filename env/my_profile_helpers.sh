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

    if [ -d "$FROM_DIR" ] ; then
        # Separating on nulls gives weird errors and doesn't work,
        # so we use another delimiter instead. We save the current IFS
        # so it doesn't affect the files we're sourcing.
        local SaveIFS="$IFS"
        local IFS
        IFS="$(printf '\x1E')" # Record Separator; octal 036

        set -a
        for CONF_FILE in $(find "$FROM_DIR" -maxdepth 1 \
                -type f ${1:+"$@"} -printf '%h/%f\036' \
            | LC_COLLATE=POSIX sort)
        do
            # shellcheck disable=SC1090 # sourcing non-constant file -- no kidding!
            IFS="$SaveIFS" . "$CONF_FILE"
        done
        set +a
    fi
}
