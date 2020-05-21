#!/bin/sh
#
# This file can be used to run your own custom X setup. It must be executable
# and named ~/.xsession for this to work.
#
# For OpenBSD, this file is REQUIRED for your custom X session to work.
# For Linux, you will need a file in /usr/share/xsessions, possibly named
# xsession.desktop, with contents like the following:
#
#  [Desktop Entry]
#  Version=1.0
#  Name=User Xsession
#  Comment=Use your .xsession file to control the desktop.
#  Exec=/etc/X11/Xsession
#  Icon=
#  Type=Application
#
# If /etc/X11/Xsession doesn't exist, try /etc/X11/xinit/Xsession.
#
# The X session ends when the process running this script ends. So, you want
# the final line to "exec" your session manager, or some other process
# that will last as long as you need your X session.

# Source .xprofile (which see for information)
. "$HOME/.xprofile"

# Don't abort if the first exec fails
shopt -s execfail

#exec startxfce4
exec openbox-session

##########
## Simplest xsession: failsafe
exec /usr/bin/xterm
