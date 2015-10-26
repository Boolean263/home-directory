#!/bin/bash

NEWPATH=""

while read line ; do
    if [ "${line/\/Program Files//}" = "$line" ] ; then
        export NEWPATH="$NEWPATH${NEWPATH:+:}$line"
    else
        :
        #echo "Drop: '$line'"
    fi
done < <( echo "$PATH" | tr ':' '\n' )

export PATH="$NEWPATH"
