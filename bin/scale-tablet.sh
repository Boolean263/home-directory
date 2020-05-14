#!/bin/sh

MATCH_STR="WP8060U Pen Pen"

XRESTRICT="$HOME/git/xrestrict/src/xrestrict"

DEVICEID=$(xinput | perl -ne"/$MATCH_STR.*\bid=(\d+)/ and print(\$1)")
if [ -z "$DEVICEID" ] ; then
    echo "Tablet not found matching '$MATCH_STR'" 1>&2
    exit 1
fi

"$XRESTRICT" -d $DEVICEID --fit -Y top
