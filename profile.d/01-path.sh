#!/usr/bin/env bash

# Removes duplicate paths from a PATH style string while retaining the order
puniq() {
    echo "$1" | tr : '\n' | nl | sort -u -k 2,2 | sort -n |
    cut -f 2- | tr '\n' : | sed -e 's/:$//' -e 's/^://'
}

# Adds a path to the end of PATH if the path exists and is a directory
path_push () {
    [ -d "$1" ] && PATH=$(puniq "$PATH:$1")
}

# Adds a path to the beginning of PATH if the path exists and is a directory
path_unshift () {
    [ -d "$1" ] && PATH=$(puniq "$1:$PATH")
}

# I like installing stuff I manage in ~/.local instead of /usr/local
path_unshift "$HOME/.local/bin"
