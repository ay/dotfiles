#!/usr/bin/env bash

path_unshift "$HOME/.homebrew/bin"

if command -v brew > /dev/null ; then

    # Opt-out of analytics
    export HOMEBREW_NO_ANALYTICS=1

    # Load bash completion
    if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
        source "$(brew --prefix)/etc/bash_completion"
    fi

fi
