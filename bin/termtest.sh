#!/bin/sh
#
# NB. In "pure" sh mode, `echo -ne` doesn't work. Use `printf`.
# (the shell builtin is MUCH faster than the separate binary)
#PRINTF=/usr/bin/printf
PRINTF=printf

title()
{
    if [ $# -eq 2 ] ; then
        $PRINTF '%7s: %s\n' $1 "$2"
    else
        $PRINTF '%7s: ' $1
    fi
}

newline()
{
    tput sgr0
    echo
}

setfg()
{
    if [ $# -eq 3 ] ; then
        $PRINTF '\e[38;2;%d;%d;%dm' $1 $2 $3
    else
        $PRINTF '\e[38;5;%dm' $1
    fi
}

setbg()
{
    if [ $# -eq 3 ] ; then
        $PRINTF '\e[48;2;%d;%d;%dm' $1 $2 $3
    else
        $PRINTF '\e[48;5;%dm' $1
    fi
}

show_effects()
{
    title 'Effects'
    local spc="$(tput sgr0) "
    tput bold;  $PRINTF "Bold$spc"
    tput rev;   $PRINTF "Rvs$spc"
    tput smso;  $PRINTF "StdOut$spc"
    tput dim;   $PRINTF "Dim$spc"
    tput sitm;  $PRINTF "Ital$spc"
    tput smul;  $PRINTF "Und$spc"
    tput blink; $PRINTF "Blink$spc"
    tput invis; $PRINTF "Invis$spc"
    tput bold dim sitm smul ; $PRINTF "Combo"
    newline

    title 'More'
    $PRINTF     '\e[21mDblUnd'"$spc"
    $PRINTF     '\e[9mStkout'"$spc"
    $PRINTF     '\e[4;3mCurl'"$spc"
    $PRINTF     '\e[4;4mDot'"$spc"
    $PRINTF     '\e[4;5mDash'"$spc"
    newline
}

basic_colours()
{
    local C=0
    title 'Colours'
    while [ $C -lt 16 ] ; do
        setbg $C
        $PRINTF ' %02d ' $C
        C=$(( $C + 1 ))
    done
    newline
}

show_256colours()
{
    local C=232 # colour number
    title 'Grays'
    while [ $C -lt 256 ] ; do
        setbg $C
        setfg $(( 232+(255-$C) ))
        $PRINTF '<>'
        C=$(( $C + 1 ))
    done
    newline

    local FG BG
    for R in 0 2 4 ; do # row
        title "256"
        FG=$(( 16+(6*$R) ))
        BG=$(( 16+(6*($R+1)) ))
        for N in 0 1 2 3 4 5 ; do # cube face
            $PRINTF ' '
            for X in 0 1 2 3 4 5 ; do # column
                setfg $(( $FG+$X ))
                setbg $(( $BG+$X ))
                $PRINTF '▀'
            done
            tput sgr0
            FG=$(( $FG+36 ))
            BG=$(( $BG+36 ))
        done
        newline
    done
}

show_truecolour()
{
    # I borrowed this algorithm from an awk script found on the internet
    title 'RGB'
    local N=$(tput cols) ; N=$(($N-11)) # Number of columns to show
    for C in $(seq 0 $N) ; do
        local r=$(( 255 - ( ($C*255/$N) % 256) ))
        local g=$(( $C*510/$N ))
        if [ $g -gt 255 ] ; then g=$(( 510-$g )) ; fi
        local b=$(( $C*255/$N ))
        setfg $(( 255-$r )) $(( 255-$g )) $(( 255-$b ))
        setbg $r $g $b
        $PRINTF '*'
    done
    newline
}

test_utf8()
{
    title 'ASCII' '1lI|DO08Bb6gq'
    title 'Accents' 'C’est ça, la bibliothèque, août, noël, mañana'
    title 'Combo' 'S̶t̶r̶i̶k̶e̶o̶u̶t̶'
    title 'Symbols' '2H₂ + O₂ ⇌ 2H₂O   aⁱ-bⁱ   ☺☹♠♥♣♦♤♡♧♢ 😀🙂😐🙁😦  1–2  but—why?'
    title 'Boxes' '█ ▁▂▃▄▅▆▇█  ░░▒▒▓▓██'
    echo '         ▉ ╔══╦══╗  ┌──┬──┐  ╭──┬──╮  ╭──┬──╮  ┏━━┳━━┓  ┎┒┏┑   ╷  ╻ ┏┯┓ ┌┰┐  '
    echo '         ▊ ║┌─╨─┐║  │╔═╧═╗│  │╒═╪═╕│  │╓─╁─╖│  ┃┌─╂─┐┃  ┗╃╄┙  ╶┼╴╺╋╸┠┼┨ ┝╋┥  '
    echo '         ▋ ║│╲ ╱│║  │║   ║│  ││ │ ││  │║ ┃ ║│  ┃│ ╿ │┃  ┍╅╆┓   ╵  ╹ ┗┷┛ └┸┘  '
    echo '         ▌ ╠╡ ╳ ╞╣  ├╢   ╟┤  ├┼─┼─┼┤  ├╫─╂─╫┤  ┣┿╾┼╼┿┫  ┕┛┖┚    ┌┄┄┐ ╎ ┏┅┅┓ ┋'
    echo '         ▍ ║│╱ ╲│║  │║   ║│  ││ │ ││  │║ ┃ ║│  ┃│ ╽ │┃  ▗▄▖▛▀▜  ┊  ┆ ╎ ╏  ┇ ┋'
    echo '         ▎ ║└─╥─┘║  │╚═╤═╝│  │╘═╪═╛│  │╙─╀─╜│  ┃└─╂─┘┃  ▝▀▘▙▄▟  ┊  ┆ ╎ ╏  ┇ ┋'
    echo '         ▏ ╚══╩══╝  └──┴──┘  ╰──┴──╯  ╰──┴──╯  ┗━━┻━━┛          └╌╌┘ ╎ ┗╍╍┛ ┋'
}

title "Size" "$(tput cols)×$(tput lines)"
title 'Env' "TERM=$TERM COLORTERM=$COLORTERM SHELL=$SHELL"
test_utf8
show_effects
basic_colours
show_256colours
show_truecolour
