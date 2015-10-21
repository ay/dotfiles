#!/usr/bin/env bash

if [ -d "$HOME/.local/java/Home" ]; then
    export JAVA_HOME="$HOME/.local/java/Home"
    path_unshift "$JAVA_HOME/bin"
fi
