#!/usr/bin/env bash

# System-wide bash-completion
for completion in "/etc/bash_completion" "/usr/local/etc/bash_completion"; do
    if [ -f "$completion" ] && ! shopt -oq posix; then
        source "$completion"
    fi
done

# AWS CLI command completion
if command -v aws > /dev/null && command -v aws_completer > /dev/null ; then
    complete -C aws_completer aws
fi
