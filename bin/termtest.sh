#!/bin/bash

show_attrs()
{
    # bash-specific syntax: indexed arrays
    local NAMES=(norm rvrs sout bold dimm ital shad und1 blnk  secr)
    local CODES=(sgr0 rev  smso bold dim  sitm sshm smul blink invis)
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
            tput ${CODES[$c]}
            [ $r -eq 0 ] || tput ${CODES[$r]}
            printf "$FMT" "$TEST"
            tput sgr0
        done
        echo
    done
}

echo "Current TERM is $TERM"
show_attrs
truecolour.awk
