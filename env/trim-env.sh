#!/bin/bash

NEWPATH=""

while read line ; do
    if [ "${line/\/Program Files\//}" != "$line" ] ; then
        :
        #echo "Drop: '$line'"
    elif [ "${line/\/cygdrive\//}" != "$line" ] ; then
        :
        #echo "Drop: '$line'"
    else
        export NEWPATH="$NEWPATH${NEWPATH:+:}$line"
    fi
done < <( echo "$PATH" | tr ':' '\n' )

export PATH="$NEWPATH"
