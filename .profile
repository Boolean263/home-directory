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

. $HOME/etc/env/path_functions.bash

# set PATH so it includes user's private bin if it exists
#if [ -d "$HOME/.plenv/bin" ] ; then
#    export PATH="$HOME/.plenv/bin:$PATH"
#fi
add_to_path PATH "$HOME/bin"

export LC_COLLATE=POSIX
export PAGER="`which less` -R"
export BC_ENV_ARGS="$HOME/.bcrc"
export VISUAL='/usr/bin/vim'
export EDITOR="$VISUAL"
export INPUTRC="$HOME/.inputrc"
#export GREP_OPTIONS="--colour --exclude-dir=.svn"
export LESS="-R"
export LESSOPEN="|lesspipe.sh %s"

export HISTCONTROL="ignorespace:ignoredups"
export FIGNORE="CVS:\~:.o:.svn:.git:.lo"

export NYTPROF="addpid=1"
export DBIC_TRACE_PROFILE=console
export TEST_JOBS=9

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
export PYTHONPATH="$HOME/lib/python2.7/site-packages"

export ANDROID_HOME="$HOME/Android/Sdk"

export MANPAGER="$HOME/bin/manpager"
export PERLDOC_PAGER="$PAGER"

# Force apps to use the classic X input method, chiefly to support
# the settings in my .XCompose file.
export CLUTTER_IM_MODULE=xim
export QT_IM_MODULE=xim
export QT4_IM_MODULE=xim
export GTK_IM_MODULE=xim

export GPGKEY="310835C6"

[ -f "$HOME/.profile.local" ] && . "$HOME/.profile.local" || :
