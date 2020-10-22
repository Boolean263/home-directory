#!/bin/sh

SELF="$0"

for c in xfce4-terminal telnet konwert ; do
    if ! which "$c" >/dev/null; then
        echo "Missing required program: $c" 1>&2
        exit 1
    fi
done

if [ "$1" = "do-telnet" ] ; then
    NHPASS=$(cat ~/.nhpasswd)
    telnet -l "Boolean263:$NHPASS" nethack.alt.org | konwert cp437-UTF8
else
    xfce4-terminal --geometry=80x25 --font="Monospace 18" \
        --hide-menubar --hide-toolbar --hide-scrollbar \
        -e "$SELF do-telnet"
fi
