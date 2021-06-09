# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# I call it from my ~/.bash_profile (which see, and which also runs
# my .bashrc for login shells).

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# Try to prevent dash from choking, but it doesn't seem to work
[ "${0#*-}" = "dash" ] && export PS1='[\u@\h \W]\$ ' || :

# Get environment from ~/.config/environment.d/ files.
# See ~/.config/environment.d/README.md for more information.
# Test for ENV_TEST_ENVD (which I set in ~/.config/environment.d/)
# to avoid needless re-setting.
ENVIRONMENTD="$HOME/.config/environment.d"
set -a
if [ -d "$ENVIRONMENTD" ] ; then
    for conf in $(ls "$ENVIRONMENTD"/*.conf | sed 's/ /?/g'); do
        . "$conf"
    done
fi
set +a
unset conf

. "$HOME/env/path_functions.bash"
clean_path PATH

export PAGER=$(type -p less)
export VISUAL=$(type -p nvim vim vi | head -n 1)
export EDITOR="$VISUAL"
export GIT_EDITOR="$VISUAL -f"
#export GVIM="$HOME/bin/ngvim"

export LESS="-R"
exists lesspipe && eval "$(lesspipe)" || :

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
myim=$(type -p fcitx5 fcitx | head -n 1)
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

[ -d "/tmp" ] && export TEMP="/tmp" || :

[ -f "$HOME/.profile.local" ] && . "$HOME/.profile.local" || :
