#!/bin/sh

# Prevent from running more than once per X session
if xrdb -query | grep -Eq '^awesome\.started:\s*true$'; then
    exit
fi
echo 'awesome.started: true' | xrdb -merge -

AWESOME_CONFIG_DIR="$HOME/.config/awesome"
cd "$AWESOME_CONFIG_DIR"

# Clone some extra repos here
for repo in \
    https://github.com/streetturtle/awesome-buttons.git \
    https://github.com/streetturtle/awesome-wm-widgets.git \
    https://github.com/xinhaoyuan/layout-machi.git \
; do
    dirname=${repo%%.git}
    dirname="$AWESOME_CONFIG_DIR/${dirname##*/}"
    if [ -d "$dirname" ] ; then
        (cd "$dirname" && git pull)
    else
        git clone "$repo"
    fi
done

# Start the usual X "autostart" things (see my ~/.config/autostart)
xdg-autostart awesomewm

# Compositing manager
compton &
