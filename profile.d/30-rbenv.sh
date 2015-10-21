#!/usr/bin/env bash

if [ -d "$HOME/.rbenv" ]; then
    path_unshift "$HOME/.rbenv/bin"
    eval "$(rbenv init -)"
fi
