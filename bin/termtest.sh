#!/bin/bash

echo "Current TERM is $TERM"

NAMES=(norm rvrs sout bold dimm ital shad und1 blnk  secr)
CODES=(sgr0 rev  smso bold dim  sitm sshm smul blink invis)
TEST="ABCD"
FMT=" %4s "

SEQEND=$((${#NAMES[*]} - 1))

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
