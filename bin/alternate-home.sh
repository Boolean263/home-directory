#!/bin/sh

set -eu

usage()
{
    if [ -n "$1" ] ; then
        echo "Error: $@" 1>&2
        echo 1>&2
    fi
    cat 1>&2 <<EOT
This script runs the given command with HOME set to
a temporary directory.

Usage:
    $0 [-d /some/directory] command [arguments ...]
EOT
    exit 1
}

USE_DIR=
TMP_HOME=

case "$1" in
    ""|-h|--help)
        usage
        ;;
    -d)
        shift
        USE_DIR="$1"
        shift
        if ! [ -d "$USE_DIR" ] ; then
            usage "Directory does not exist: $USE_DIR"
        fi
        ;;
esac

unset \
    XDG_DATA_HOME \
    XDG_CONFIG_HOME \
    XDG_CACHE_HOME \
    XDG_STATE_HOME \
    XDG_RUNTIME_DIR

if [ -n "$USE_DIR" ] ; then
    export HOME=$(readlink -f "$USE_DIR")
else
    TMP_HOME=$(mktemp -p "${TMPDIR:-/tmp}" -d alternate-home.XXXXXX)
    export HOME="$TMP_HOME"
fi

CMD="$1"
shift
if [ -z "$CMD" ] ; then
    usage
fi

set +e
"$CMD" ${1:+"$@"}
RV=$?
set -e

if [ -n "$TMP_HOME" ] ; then
    if [ $RV -eq 0 ] ; then
        rm -rf "$TMP_HOME"
    else
        echo "[keeping temporary home directory] $TMP_HOME"
    fi
fi
exit $RV
