#!/bin/sh

# Prevent from running more than once per X session
if xrdb -query | grep -q '^awesome\.started:\s*true$'; then exit; fi
echo 'awesome.started: true' | xrdb -merge -


# Start the usual X "autostart" things (see my ~/.config/autostart)
xdg-autostart awesomewm
