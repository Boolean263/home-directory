#!/bin/bash

###
### Are you REALLY SURE you don't want to do this in perl instead?
### The last few times you've tried to use bash scripts, it's quickly
### gone wahooney-shaped.
###

###
### Globals and important variables
###

VERBOSE=0

###
### Functopns
###

usage()
{
    [ -n "$*" ] && echo "Error: $*" 1>&2 && echo 1>&2
    cat 1>&2 <<EOT
${1:"Summarize this script's purpose here."}

Usage:
    \$0 [options] ...

Options:
    -v, --verbose               Increase verbosity
    -q, --quiet                 Decrease verbosity
    -h, --help                  Show this help message
EOT
    exit 1
}

verbecho()
{
    local level="\$1"
    shift
    local message="$*"
    [ "$VERBOSE" -ge "$level" ] && echo "$message"
}

errecho()
{
    echo "$*" 1>&2
}

###
### Main
###

# Process arguments
while [ -n "\$1" ] ; do
    case "\$1" in
        -v|--verbose)
            # Increase verbosity
            VERBOSE=$(( $VERBOSE + 1 ))
            ;;
        -q|--quiet)
            # Decrease verbosity
            VERBOSE=$(( $VERBOSE - 1 ))
            ;;
        -h|--help)
            # Show help message
            usage
            ;;
        --)
            # Allow follow-on arguments to start with '-' and not be options
            shift
            break
            ;;
        -*)
            # Show error on unrecognized options
            usage "Unrecognized option '\$1'"
            ;;
        *)
            # Stop processing arguments when a non-option argument is found
            break
            ;;
    esac
    shift
done

# Perform main activity
${0}

#
# Editor modelines - http://www.wireshark.org/tools/modelines.html
#
# Local variables:
# c-basic-offset: 4
# tab-width: 4
# indent-tabs-mode: nil
# coding: utf-8
# End:
#
# vi:set shiftwidth=4 tabstop=4 expandtab fileencoding=utf-8:
# :indentSize=4:tabSize=4:noTabs=true:coding=utf-8:
