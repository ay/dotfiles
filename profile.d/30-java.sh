#!/usr/bin/env bash

if [ -d "$HOME/.local/java" ]; then
    export JAVA_HOME="$HOME/.local/java"
    path_unshift "$JAVA_HOME/bin"
fi
