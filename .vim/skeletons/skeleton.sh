#!/bin/bash

###
### Are you REALLY SURE you don't want to do this in perl instead?
### The last few times you've tried to use bash scripts, it's quickly
### gone wahooney-shaped.
###

###
### "Strict mode" bash
### http://redsymbol.net/articles/unofficial-bash-strict-mode/
###
strict()
{
    set -euo pipefail
    IFS=$'\n'
}
unstrict()
{
    IFS=$' \n\t'
    set +eu
    set -o nopipefail
}
strict

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
