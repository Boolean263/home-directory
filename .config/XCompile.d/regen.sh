#!/bin/sh

INPUT_DIR=$(dirname $(readlink -f $0))
OUTPUT_FILE=${XCOMPOSEFILE:-$HOME/.XCompose}


~/git/NXCompile/NXCompile -s -n -o "$OUTPUT_FILE" "$INPUT_DIR"/*.txt

cat >> "$OUTPUT_FILE" << EOT

# Include the standard xcompose bindings
# (This needs to be at the end for fcitx)
include "%L"

# By the way, this file was automatically generated by
# $INPUT_DIR/regen.sh
EOT

fixkeys
