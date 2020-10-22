#!/bin/bash

show_attrs()
{
    # bash-specific syntax: indexed arrays
    local NAMES=(
        norm
        rvrs
        sout
        bold
        dimm
        ital
        und1
        und2
        blnk
        secr
        strk
    )
    local CODES=(
        $(tput sgr0)
        $(tput rev)
        $(tput smso)
        $(tput bold)
        $(tput dim)
        $(tput sitm)
        $(tput smul)
        $'\e[21m'
        $(tput blink)
        $(tput invis)
        $'\e[9m'
    )
    local TEST="ABCD"
    local FMT=" %4s "

    local SEQEND=$((${#NAMES[*]} - 1))

    printf "$FMT" "++++"
    for i in $(seq 0 $SEQEND) ; do
        printf "$FMT" "${NAMES[$i]}"
    done
    echo

    for r in $(seq 0 $SEQEND) ; do
        printf "$FMT" "${NAMES[$r]}"
        for c in $(seq 0 $SEQEND) ; do
            printf "%s" "${CODES[$c]}"
            [ $r -eq 0 ] || printf "%s" "${CODES[$r]}"
            printf "$FMT" "$TEST"
            tput sgr0
        done
        echo
    done
}

echo "Current TERM is $TERM"
show_attrs
echo
truecolour.awk
