#!/bin/sh
# ~/.profile: traditionally used to configure session-wide settings.
# Mainly environment variables, possibly some startup programs.
# This file gets sourced by login shells. It *may* also get called
# by the login manager or desktop environment.
# (Source: <https://superuser.com/a/183980/627623>)
# I also call it from my ~/.xprofile (which in turn can be called by
# my ~/.xsession) -- this means I can't have bash-isms in here.

# More recently, some desktop environments *don't* use this file,
# but use files in ~/.config/environment.d/ instead.
# See ~/.config/environment.d/README.md for more information.
# In an attempt to reduce duplicate settings, I'm moving what settings
# I can into there, and using this structure to load them from there.
# Test for ENV_TEST_ENVD (which I set in ~/.config/environment.d/)
# to avoid needless re-setting.
ENVIRONMENTD="$HOME/.config/environment.d"
#if [ -d "$ENVIRONMENTD" ] && [ -z "$ENV_TEST_ENVD" ] ; then
if [ -d "$ENVIRONMENTD" ] ; then
    set -a
    for conf in $(ls "$ENVIRONMENTD"/*.conf | sed 's/ /?/g'); do
        . "$conf"
    done
    set +a
fi
unset conf ENVIRONMENTD

. "$HOME/env/path_functions.sh"
clean_path PATH

export PAGER=$(which less)
export VISUAL=$(which nvim vim vi nvi 2>/dev/null | head -n 1)
export EDITOR="$VISUAL"
export GIT_EDITOR="$VISUAL -f"

export LESS="-R"
eval "$(lessfile)"

export FIGNORE="CVS:\~:.o:.svn:.git:.lo"

export NYTPROF="addpid=1"
export DBIC_TRACE_PROFILE=console
export TEST_JOBS=9

export UBUNTU_MENUPROXY=

export MANPAGER="$HOME/bin/manpager"
export PERLDOC_PAGER="$PAGER"

# Use fcitx if we can; otherwise,
# Force apps to use the classic X input method, chiefly to support
# the settings in my .XCompose file.
myim=$(which fcitx5 fcitx 2>/dev/null | head -n 1)
myim=${myim:-xim}
exists fcitx && myim=fcitx || myim=xim
export CLUTTER_IM_MODULE=$myim
export QT_IM_MODULE=$myim
export QT4_IM_MODULE=$myim
export GTK_IM_MODULE=$myim
export XMODIFIERS="@im=$myim"
unset myim

# Go all in on Wayland if it's in use
if [ -n "$WAYLAND_DISPLAY" ] ; then
    export MOZ_ENABLE_WAYLAND=1
    export GDK_BACKEND=wayland
    export MOZ_DBUS_REMOTE=1
fi

export GPGKEY="310835C6"

# Build in parallel when possible
if [ -r /proc/cpuinfo ] ; then
    export CMAKE_BUILD_PARALLEL_LEVEL=$(grep -c ^processor /proc/cpuinfo)
    export MAKEFLAGS=-j$CMAKE_BUILD_PARALLEL_LEVEL
fi

if [ -d "/tmp" ] ; then
    export TEMP="/tmp"
fi

# Use my custom-generated locale
if "$XDG_CONFIG_HOME/locale/regen.sh" ; then
    export LOCPATH="$HOME/.local/locale"
    export LANG=en_CA.UTF-8
    export LC_ALL=en_CA.UTF-8
fi
# ... but still collate ASCIIbetically
export LC_COLLATE=POSIX

if exists luarocks ; then
    eval $(luarocks path --no-bin)
fi

if [ -f "$HOME/.profile.local" ] ; then
    . "$HOME/.profile.local"
fi
