#!/bin/sh

# Update rust itself
rustup update

# Update packages installed via cargo
# via https://stackoverflow.com/q/60857222/6692652
cargo install \
    $(cargo install --list | awk '/^\S[^(]+$/{print $1}')

echo
echo "You’ll need to manually update these packages from git:"
cargo install --list \
    | grep -F '(' \
    | sed -E 's/^(.+):$/• \1/'
