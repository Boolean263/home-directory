# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
#if [ -n "$BASH_VERSION" ]; then
#    # include .bashrc if it exists
#    if [ -f "$HOME/.bashrc" ]; then
#	. "$HOME/.bashrc"
#    fi
#fi

# Try to prevent dash from choking, but it doesn't seem to work
[ "${0#*-}" = "dash" ] && export PS1='[\u@\h \W]\$ ' || :

# Though it's named '.bash', I've tweaked it to work with ksh as well
. $HOME/etc/env/path_functions.bash

# Need this in cygwin for some reason
add_to_path PATH /usr/local/bin
#add_to_path MANPATH /usr/local/man
#add_to_path LD_LIBRARY_PATH /usr/local/lib

# i3-sensible-desktop uses this to find the user's preferred terminal emulator
export TERMINAL="$HOME/bin/term"

# set PATH so it includes user's private bin if it exists
#if [ -d "$HOME/.plenv/bin" ] ; then
#    export PATH="$HOME/.plenv/bin:$PATH"
#fi
add_to_path PATH "$HOME/bin" "$HOME/.cargo/bin"

export LC_COLLATE=POSIX
export PAGER="$(which less) -R"
export BC_ENV_ARGS="$HOME/.bcrc"
export VISUAL=$(which nvim vim vi | head -n 1 2>/dev/null)
export EDITOR="$VISUAL"
export GIT_EDITOR="$VISUAL -f"
export INPUTRC="$HOME/.inputrc"
#export GREP_OPTIONS="--colour --exclude-dir=.svn"
export LESS="-R"
#export LESSOPEN="|lesspipe.sh %s"

export HISTCONTROL="ignorespace:ignoredups"
export FIGNORE="CVS:\~:.o:.svn:.git:.lo"

export NYTPROF="addpid=1"
export DBIC_TRACE_PROFILE=console
export TEST_JOBS=9
export TERMINFO="$HOME/.terminfo"

export UBUNTU_MENUPROXY=

export COLORTERM="truecolor"

export PERL_CPANM_OPT="-n"
export MYPERLDIR="$HOME/perl5"
add_to_path PATH "$MYPERLDIR/bin"
add_to_path PERL5LIB "$MYPERLDIR/lib/perl5"
export PERL_LOCAL_LIB_ROOT="$MYPERLDIR${PERL_LOCAL_LIB_ROOT+:}$PERL_LOCAL_LIB_ROOT"
export PERL_MB_OPT="--install_base \"$MYPERLDIR\""
export PERL_MM_OPT="INSTALL_BASE=$MYPERLDIR"


#export PERLBREW_ROOT="$HOME/perl5/perlbrew"

export PYTHONUSERBASE="$HOME"

export MANPAGER="$HOME/bin/manpager"
export PERLDOC_PAGER="$PAGER"

# Use fcitx if we can; otherwise,
# Force apps to use the classic X input method, chiefly to support
# the settings in my .XCompose file.
export XMODIFIERS="@im=none"
which fcitx >/dev/null 2>&1 && myim=fcitx || myim=xim
export CLUTTER_IM_MODULE=$myim
export QT_IM_MODULE=$myim
export QT4_IM_MODULE=$myim
export GTK_IM_MODULE=$myim
unset myim

export GPGKEY="310835C6"

export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

[ -f "$HOME/.profile.local" ] && . "$HOME/.profile.local" || :
