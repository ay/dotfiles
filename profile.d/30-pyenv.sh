#!/usr/bin/env bash

if [ -d "$HOME/.pyenv" ]; then

    # Initialize pyenv
    export PYENV_ROOT="$HOME/.pyenv"
    path_unshift "$HOME/.pyenv/bin"
    eval "$(pyenv init -)"

    # Initialize virtualenvwrapper
    if [ -f "$HOME/.pyenv/version" ]; then
        python_version="$(cat $HOME/.pyenv/version)"
        if [ -f "$PYENV_ROOT/versions/$python_version/bin/virtualenvwrapper.sh" ]; then
            [ -d "$HOME/.virtualenvs" ] || mkdir -p "$HOME/.virtualenvs"
            export WORKON_HOME="$HOME/.virtualenvs"
            source "$PYENV_ROOT/versions/$python_version/bin/virtualenvwrapper.sh"
            export VIRTUALENV_USE_DISTRIBUTE=true
            export PIP_VIRTUALENV_BASE="$WORKON_HOME"
            export PIP_REQUIRE_VIRTUALENV=false
            export PIP_RESPECT_VIRTUALENV=true
            export PIP_DOWNLOAD_CACHE="$HOME/.pip/cache"
            export VIRTUAL_ENV_DISABLE_PROMPT=true
        fi
        unset python_version
    fi

fi
