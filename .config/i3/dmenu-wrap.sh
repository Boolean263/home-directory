#!/bin/sh
# Wrapper inspired by /usr/bin/dmenu_run

dmenu_path | dmenu "$@" | xargs notify-exec.sh &
