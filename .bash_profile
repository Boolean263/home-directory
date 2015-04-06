# .bash_profile is called by bash when a LOGIN shell is started.
# .bashrc is called by bash when a NON-LOGIN shell is started.
# I want my .profile and such called always, so even my bash-specific
# environment settings are in .profile, and .bash_profile is just a
# call to .bashrc.
[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
