#!/bin/sh

set -eu

usage()
{
    cat 1>&2 <<EOT
${1:+Error: $*}
This script runs the given command with HOME set to
a temporary directory.

Usage:
    $0 [-d /some/directory] command [arguments ...]
EOT
    exit 1
}

USE_DIR=
TMP_HOME=

if [ -z "${1:-}" ] ; then
    usage "missing command"
fi

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
    HOME="$(readlink -f "$USE_DIR")"
    export HOME
else
    TMP_HOME=$(mktemp -p "${TMPDIR:-/tmp}" -d alternate-home.XXXXXX)
    export HOME="$TMP_HOME"
fi

CMD="${1:-}"
if [ -z "$CMD" ] ; then
    usage "missing command"
fi
shift

set +e
"$CMD" ${1:+"$@"}
RV=$?
set -e

if [ -n "$TMP_HOME" ] ; then
    if [ $RV -eq 0 ] ; then
        rm -rf "$TMP_HOME"
    else
        TMP_CONTENTS=$(find "$TMP_HOME" -type f -size +0 -print -quit)
        if [ -n "$TMP_CONTENTS" ] ; then
            echo "[keeping non-empty temporary home directory] $TMP_HOME" 1>&2
        else
            rm -rf "$TMP_HOME"
        fi
    fi
fi
exit $RV
