#!/bin/sh
#
# Script to (re)generate locale files for my customized
# en_CA settings. Inspired by `man 1 locale`.
# For the generated locale to be used, you need to set
# LOCPATH to the same value as used here, and LANG
# to "en_CA.UTF-8".

# Input location of source files
export I18NPATH=$(dirname $(readlink -f "$0"))

# Output location of generated file
export LOCPATH="$HOME/.local/locale"

mkdir -p "$LOCPATH/en_CA.UTF-8"
if ! [ -f "$LOCPATH/en_CA.UTF-8/LC_TIME" ] || \
     [ "$I18NPATH/en_CA" -nt "$LOCPATH/en_CA.UTF-8/LC_TIME" ]
then
    localedef -f UTF-8 -i en_CA "$LOCPATH/en_CA.UTF-8"
fi
