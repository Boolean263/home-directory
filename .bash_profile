# .bash_profile is called by bash when a LOGIN shell is started.
# .bashrc is called by bash when a NON-LOGIN shell is started.
# As per https://superuser.com/a/183980/627623 :
#
# ~/.profile is the place to put stuff that applies to your whole session, such
# as programs that you want to start when you log in (but not graphical
# programs, they go into a different file), and environment variable
# definitions.
#
# ~/.bashrc is the place to put stuff that applies only to bash itself, such as
# alias and function definitions, shell options, and prompt settings. (You
# could also put key bindings there, but for bash they normally go into
# ~/.inputrc.)
#
# Based on that logic, and the recommendation in the above answer, this script
# now calls .profile and .bashrc, not the other way around.

if [ -r ~/.profile ]; then . ~/.profile; fi
case "$-" in *i*) if [ -r ~/.bashrc ]; then . ~/.bashrc; fi;; esac

