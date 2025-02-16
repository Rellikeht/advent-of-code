#!/usr/bin/env sh

NR=1
if [ -n "$1" ]; then
    NR="$1"
fi

"./target/debug/sol$NR" | dot -Tpng /dev/stdin | feh -
