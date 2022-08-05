#!/bin/bash
# ~/.bash_profile: this file is sourced instead of ~/.profile
# when bash is launched as a login shell. So, let's just use it
# to source ~/.profile, and then if we're an interactive shell,
# to also source ~/.bashrc .
# (Source: <https://superuser.com/a/183980/627623>)

if [ -r ~/.profile ] ; then
    . ~/.profile
fi

case "$-" in
    *i*)
        if [ -r ~/.bashrc ]; then
            . ~/.bashrc
        fi
        ;;
esac

