#!/bin/sh

#cat ~/.XCompile.d/*.txt | ~/git/XCompile/XCompile > ~/.XCompiled
~/git/NXCompile/NXCompile -s -n -o ~/.XCompiled ~/.XCompile.d/*.txt

fixkeys
