#!/usr/bin/env bash

if [ -d "$HOME/.local/lib/mit-scheme" ]; then
    export MITSCHEME_LIBRARY_PATH="$HOME/.local/lib/mit-scheme"
fi
