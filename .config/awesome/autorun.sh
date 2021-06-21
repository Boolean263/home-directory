#!/bin/sh

# Prevent from running more than once per X session
if xrdb -query | grep -q '^awesome\.started:\s*true$'; then exit; fi
echo 'awesome.started: true' | xrdb -merge -

# Clone some extra repos here
for repo in \
    https://github.com/streetturtle/awesome-buttons \
    git@github.com:streetturtle/awesome-wm-widgets.git \
    git@github.com:xinhaoyuan/layout-machi.git \
; do
    dirname=${repo%%.git}
    dirname=${dirname##*/}
    if [ -d "$dirname" ] ; then
        (cd "$dirname" && git fetch)
    else
        git clone "$repo"
    fi
done

# Start the usual X "autostart" things (see my ~/.config/autostart)
xdg-autostart awesomewm

# Compositing manager
compton &
