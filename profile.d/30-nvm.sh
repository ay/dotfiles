#!/usr/bin/env bash

if [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
    source "$NVM_DIR/nvm.sh"
    [ -f "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
fi
