#!/usr/bin/env bash

path_unshift "$HOME/.homebrew/bin"

# Opt-out of Homebrew's analytics
if command -v brew > /dev/null ; then
    export HOMEBREW_NO_ANALYTICS=1
fi
