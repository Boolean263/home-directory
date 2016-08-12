#!/bin/bash
#
# Shell (bash) functions for manipulating colon-separated paths.
# Mainly useful by other shell scripts.

### is_in_path
# Returns true if the directory in TESTPATH is a member in the path
# variable PATHVAR.
is_in_path()
{
    local PATHVAR="$1"
    local TESTPATH="$2"
    eval echo \$$PATHVAR | grep -q '\(^\|:\)'"$TESTPATH"'\(:\|$\)' 2>/dev/null
    return $?
}

### add_to_path
# Add to the path variable named in $1 the paths listed after, in order.
# Adds to the beginning by default, or to the end if -e is given before
# the path variable name.
add_to_path()
{
    local TO_END=
    if [ "x$1" = "x-e" ] ; then
        TO_END=1
        shift
    fi
    local PATHVAR="$1"
    shift
    local ADDPATHS=""
    while [ "x$1" != "x" ] ; do
        if ! [ -d "$1" ] ; then
            echo "add_to_path: $1 not added to $PATHVAR (not found)"
        elif ! is_in_path "$PATHVAR" "$1" && \
             ! is_in_path ADDPATHS "$1" ; then
            ADDPATHS="$ADDPATHS${ADDPATHS:+:}$1"
        fi
        shift
    done
    eval local tmppath="\$$PATHVAR"
    if [ "x$ADDPATHS" = "x" ] ; then
        : # do nothing
    elif [ "x$tmppath" = "x" ] ; then
        eval export \$PATHVAR="$ADDPATHS"
    elif [ "x$TO_END" = "x" ] ; then
        eval export \$PATHVAR="$ADDPATHS:\$$PATHVAR"
    else
        eval export \$PATHVAR="\$$PATHVAR:$ADDPATHS"
    fi
}

### del_from_path
# Remove from the path variable named in $1 the paths listed after.
del_from_path()
{
    local PATHVAR="$1"
    eval local tmppath="\$$PATHVAR"
    shift
    while [ "x$1" != "x" ] ; do
        local DELPATH="$1"
        shift
        if is_in_path "$PATHVAR" "$DELPATH" ; then
            if [ "x$tmppath" = "$DELPATH" ] ; then
                # in case it's the entirety of the path
                tmppath=""
            else
                # in case it's at the start
                tmppath="${tmppath#$DELPATH:}"

                # in case it's at the end
                tmppath="${tmppath%:$DELPATH}"

                # in case it's in the middle somewhere
                tmppath="${tmppath/:$DELPATH:/:}"
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
    eval echo '$'$PATHVAR | tr ':' '\n'
}
