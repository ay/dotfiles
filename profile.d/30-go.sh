#!/usr/bin/env bash

if [ -d "$HOME/.local/go" ]; then
    export GOROOT="$HOME/.local/go"
    path_push "$GOROOT/bin"
fi

if [ -d "$HOME/.go" ]; then
    export GOPATH="$HOME/.go"
    path_push "$GOPATH/bin"
fi
