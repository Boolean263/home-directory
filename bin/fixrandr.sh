#!/bin/sh

# Do nothing if our primary display is connected
if xrandr | grep -Eq '\sconnected primary' ; then
    exit 0
fi

# Get list of connected displays
CONNECTED="$(xrandr | awk '/\sconnected/ {print $1}')"


# If there's only one display connected, make it the primary
if [ "${CONNECTED%% *}" = "$CONNECTED" ] ; then
    xrandr --output "$CONNECTED" --primary
else
    # Maybe add smarter logic later if I need to
    echo "Multiple displays connected, I hope I picked the right one!" 1>&2
    xrandr --output "${CONNECTED%% *}" --primary
fi
