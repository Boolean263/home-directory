#!/bin/sh
#
# Shell (bash) functions for manipulating colon-separated paths.
# Mainly useful by other shell scripts, but sometimes handy manually too.
#
# bash 5.0 doesn't seem to like the older `function foo` syntax.
# To make this file work for ksh, run `alias local=typeset`
# and then source this file with something like
#    source /dev/stdin < <(sed 's/^\(.*\)()$/function \1/' etc/env/path_functions.bash)

# Tell if a runnable program exists by the given name.
exists()
{
    type -p "$1" >/dev/null
}

# Pure bash was getting slow, so I've got a helper script.
if exists python3 && exists pathify.py ; then

    add_to_path()
    {
        local args=""
        while true ; do
            case "$1" in
                -e|-f) args="$args $1" ; shift ;;
                *) break ;;
            esac
        done
        local PATHVAR="$1"
        shift
        $(pathify.py "$PATHVAR" add $args "$@")
    }

    del_from_path()
    {
        local PATHVAR="$1"
        shift
        $(pathify.py "$PATHVAR" del $*)
    }

    show_path()
    {
        pathify.py "$1" show
    }

    clean_path()
    {
        $(pathify.py "$1" clean)
    }

else
    # Helper script not available, fall back on pure bash

    ### is_in_path
    # Returns true if the directory in TESTPATH is a member in the path
    # variable PATHVAR.
    is_in_path()
    {
        local PATHVAR="$1"
        local TESTPATH="$2"
        local SEP=":"
        eval echo \$$PATHVAR | grep -q '\(^\|'"$SEP"'\)'"$TESTPATH"'\('"$SEP"'\|$\)' 2>/dev/null
        return $?
    }

    ### add_to_path
    # Add to the path variable named in $1 the paths listed after, in order.
    # Adds to the beginning by default, or to the end if -e is given before
    # the path variable name.
    # If -bDIR or -aDIR is given before the path variable name, adds the new
    # paths before or after DIR if it appears in the path.
    # Forces adding/moving the path to the requested location if -f is given
    # before the path variable name.
    add_to_path()
    {
        local TO_END=
        local FORCE=
        local SEP=":"
        local BEFORE=""
        local AFTER=""
        local SED_SEP=$'\x1F' # sed supports using UNIT SEPARATOR as a delimiter
                            # which (probably) won't appear in path names
        while true ; do
            case "$1" in
                -e) TO_END=1 ; shift ;;
                -f) FORCE=1  ; shift ;;
                -b*) BEFORE="${1#-b}" ; shift ;;
                -a*) AFTER="${1#-a}" ; TO_END=1 ; shift ;;
                *) break ;;
            esac
        done
        local PATHVAR="$1"
        if [ -d "$PATHVAR" ] ; then
            echo "add_to_path: $PATHVAR appears to be a directory, not a path variable" 1>&2
        fi
        shift
        local ADDPATHS=""
        if [ "x$BEFORE" != "x" ] && [ "x$AFTER" != "x" ] ; then
            echo "add_to_path: -b and -a cannot both be specified" 1>&2
            return 1
        fi
        while [ "x$1" != "x" ] ; do
            [ "$FORCE" = "1" ] && del_from_path "$PATHVAR" "$1"
            if ! [ -d "$1" ] ; then
                echo "add_to_path: $1 not added to $PATHVAR (not found)"
            elif ! is_in_path "$PATHVAR" "$1" && \
                ! is_in_path ADDPATHS "$1" ; then
                ADDPATHS="$ADDPATHS${ADDPATHS:+$SEP}$1"
            fi
            shift
        done
        eval local tmppath="\$$PATHVAR"
        if [ "x$ADDPATHS" = "x" ] ; then
            : # do nothing
        elif [ "x$tmppath" = "x" ] ; then
            eval export \$PATHVAR=\"$ADDPATHS\"
        elif ! [ "x$BEFORE" = "x" ] && is_in_path "$PATHVAR" "$BEFORE" ; then
            local SEDPATH=$(eval echo "\$$PATHVAR" | /bin/sed -r "s$SED_SEP"'(^|'"$SEP"')('"$BEFORE"')('"$SEP"'|$)'"$SED_SEP"'\1'"$ADDPATHS$SEP"'\2\3'"$SED_SEP")
            eval export \$PATHVAR="$SEDPATH"
        elif ! [ "x$AFTER" = "x" ] && is_in_path "$PATHVAR" "$AFTER" ; then
            local SEDPATH=$(eval echo "\$$PATHVAR" | /bin/sed -r "s$SED_SEP"'(^|'"$SEP"')('"$AFTER"')('"$SEP"'|$)'"$SED_SEP"'\1\2'"$SEP$ADDPATHS"'\3'"$SED_SEP")
            eval export \$PATHVAR="$SEDPATH"
        elif [ "x$TO_END" = "x" ] ; then
            eval export \$PATHVAR=\"$ADDPATHS$SEP\$$PATHVAR\"
        else
            eval export \$PATHVAR=\"\$$PATHVAR$SEP$ADDPATHS\"
        fi
    }

    ### del_from_path
    # Remove from the path variable named in $1 the paths listed after.
    del_from_path()
    {
        local PATHVAR="$1"
        local SEP=":"
        if [ -d "$PATHVAR" ] ; then
            echo "del_from_path: $PATHVAR appears to be a directory, not a path variable" 1>&2
        fi
        eval local tmppath=\"\$$PATHVAR\" # """
        shift
        if [ "x$1" = "x" ] ; then
            echo "del_from_path: no paths found: did you forget your PATHVAR?" 1>&2
            return 1
        fi
        while [ "x$1" != "x" ] ; do
            local DELPATH="$1"
            shift
            if is_in_path "$PATHVAR" "$DELPATH" ; then
                if [ "x$tmppath" = "x$DELPATH" ] ; then
                    # in case it's the entirety of the path
                    tmppath=""
                else
                    # in case it's at the start
                    tmppath="${tmppath#$DELPATH$SEP}"

                    # in case it's at the end
                    tmppath="${tmppath%$SEP$DELPATH}"

                    # in case it's in the middle somewhere
                    tmppath="${tmppath/$SEP$DELPATH$SEP/$SEP}"
                fi
            fi
        done
        export $PATHVAR="$tmppath"
    }

    ### show_path
    # Show the requested path variable with newlines instead of colons
    # to make it easier to read.
    show_path()
    {
        local PATHVAR="$1"
        local SEP=":"
        if [ "x$PATHVAR" = "x" ] ; then
            echo "show_path: no PATHVAR specified" 1>&2
            return 1
        fi
        eval echo '$'$PATHVAR | /usr/bin/tr "$SEP" '\n'
    }

    ### clean_path
    # Tidy the path string by removing duplicates.
    clean_path()
    {
        local PATHVAR="$1"
        local SEP=":"
        local MYARRAY
        local i
        local CONTENTS

        eval CONTENTS="\$$PATHVAR"
        unset $PATHVAR
        IFS="$SEP" read -ra MYARRAY <<< "$CONTENTS"
        add_to_path -f "$PATHVAR" "${MYARRAY[@]}"
    }
fi
