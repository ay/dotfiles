#!/bin/bash
#
# Alex Yakoubian's .bashrc

: ${HOME=~}
: ${LOGNAME=$(id -un)}
: ${UNAME=$(uname)}

# ----------------------------------------------------------------------
# Shell Options
# ----------------------------------------------------------------------

# Wrap lines correctly after resizing window
shopt -s checkwinsize

# Save a limited history
export HISTSIZE=500

# Default umask: u=rwx,g=rx,o=rx
umask 0022

# Notify of background job completion immediately
set -o notify

# Ignore backups, CVS directories, Python bytecode, Vim swap files
FIGNORE="~:CVS:#:.pyc:.swp:.swa"

# ----------------------------------------------------------------------
# Colors
# ----------------------------------------------------------------------

# Initalize dircolors if it exists (useful with GNU ls)
if command -v dircolors > /dev/null ; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Colors on GNU and BSD versions of ls
if ls --color > /dev/null 2>&1; then # GNU ls
    alias ls="ls --color=auto"
else # BSD ls
    alias ls="ls -G"
fi

# Colorful grep
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

# Initialize colors from Solarized color scheme. Color names and values from
# http://ethanschoonover.com/solarized#the-values
if tput setaf 1 &> /dev/null; then
    tput sgr0
    if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
      BASE03="\[$(tput setaf 234)\]"
      BASE02="\[$(tput setaf 235)\]"
      BASE01="\[$(tput setaf 240)\]"
      BASE00="\[$(tput setaf 241)\]"
      BASE0="\[$(tput setaf 244)\]"
      BASE1="\[$(tput setaf 245)\]"
      BASE2="\[$(tput setaf 254)\]"
      BASE3="\[$(tput setaf 230)\]"
      YELLOW="\[$(tput setaf 136)\]"
      ORANGE="\[$(tput setaf 166)\]"
      RED="\[$(tput setaf 160)\]"
      MAGENTA="\[$(tput setaf 125)\]"
      VIOLET="\[$(tput setaf 61)\]"
      BLUE="\[$(tput setaf 33)\]"
      CYAN="\[$(tput setaf 37)\]"
      GREEN="\[$(tput setaf 64)\]"
    else
      BASE03="\[$(tput setaf 8)\]"
      BASE02="\[$(tput setaf 0)\]"
      BASE01="\[$(tput setaf 10)\]"
      BASE00="\[$(tput setaf 11)\]"
      BASE0="\[$(tput setaf 12)\]"
      BASE1="\[$(tput setaf 14)\]"
      BASE2="\[$(tput setaf 7)\]"
      BASE3="\[$(tput setaf 15)\]"
      YELLOW="\[$(tput setaf 3)\]"
      ORANGE="\[$(tput setaf 9)\]"
      RED="\[$(tput setaf 1)\]"
      MAGENTA="\[$(tput setaf 5)\]"
      VIOLET="\[$(tput setaf 13)\]"
      BLUE="\[$(tput setaf 4)\]"
      CYAN="\[$(tput setaf 6)\]"
      GREEN="\[$(tput setaf 2)\]"
    fi
    BOLD="\[$(tput bold)\]"
    RESET="\[$(tput sgr0)\]"
else
    BASE03="\[\033[0;90m\]"
    BASE02="\[\033[0;30m\]"
    BASE01="\[\033[0;92m\]"
    BASE00="\[\033[0;93m\]"
    BASE0="\[\033[0;94m\]"
    BASE1="\[\033[0;96m\]"
    BASE2="\[\033[0;37m\]"
    BASE3="\[\033[0;97m\]"
    YELLOW="\[\033[0;33m\]"
    ORANGE="\[\033[0;91m\]"
    RED="\[\033[0;31m\]"
    MAGENTA="\[\033[0;35m\]"
    VIOLET="\[\033[0;95m\]"
    BLUE="\[\033[0;34m\]"
    CYAN="\[\033[0;36m\]"
    GREEN="\[\033[0;32m\]"
    BOLD="\[\033[1m\]"
    RESET="\[\033[m\]"
fi

# ----------------------------------------------------------------------
# Prompt
# ----------------------------------------------------------------------

_parse_git_dirty () {
    [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]] && echo "*"
}

_parse_git_branch () {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ (\1$(_parse_git_dirty))/"
}

# Make the prompt look scary if we are root
if [ "$LOGNAME" = "root" ]; then
    COLOR1="${RED}"
    COLOR2="${ORANGE}"
    COLOR3="${RED}"
    COLOR4="${RED}"
    P=" #"
else
    COLOR1="${ORANGE}"
    COLOR2="${YELLOW}"
    COLOR3="${GREEN}"
    COLOR4="${BLUE}"
    P=" \$"
fi

# Sets the window title
TITLE="\[\033]0;\u@\h: \w\007\]"

# Don't show hostname in prompt if the terminal is local
if [ -z "$TERM_PROGRAM" ]; then
    PS1="${COLOR1}\u${BASE0}@${COLOR2}\h${BASE0}:${COLOR3}\w${CYAN}\$(_parse_git_branch)${COLOR4}$P${RESET} ${TITLE}"
else
    PS1="${COLOR3}\w${CYAN}\$(_parse_git_branch)${COLOR4}$P${RESET} ${TITLE}"
fi
PS2="> "

# ----------------------------------------------------------------------
# Aliases
# ----------------------------------------------------------------------

# Easier navigation
alias ..="cd .."
alias ll="ls -hlF"
alias l.="ls -hlF -d .*"
alias la="ls -hla"

# Leave current session out of .bash_history
alias private="HISTFILE=/dev/null"

# Print public IP
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"

# Git
alias g="git"
alias gs="git status"
alias gc="git commit"
alias gd="git diff"
alias gdc="git diff --cached"
alias gl="git lp"

# Ruby
alias be="bundle exec"

# ----------------------------------------------------------------------
# Bash completion
# ----------------------------------------------------------------------

# SSH hostname completion based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] &&
complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh

# Load Homebrew bash-completion
if command -v brew > /dev/null && [ -f "$(brew --prefix)/etc/bash_completion" ]; then
    source $(brew --prefix)/etc/bash_completion
fi

# Load system-wide bash-completion
for completion in "/etc/bash_completion" "/usr/local/etc/bash_completion"; do
    if [ -f completion ] && ! shopt -oq posix; then
        source completion
    fi
done

# ----------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------

path_push () {
    [ -d "$1" ] && PATH="${PATH/":$1"}:$1"
}

path_unshift () {
    [ -d "$1" ] && PATH="$1:${PATH/"$1:"}"
}

# ----------------------------------------------------------------------
# Editor and Pager
# ----------------------------------------------------------------------

if command -v vim > /dev/null ; then
    export EDITOR="vim"
    export VISUAL="vim"
fi

export PAGER="less -FiRS"

# ----------------------------------------------------------------------
# Paths
# ----------------------------------------------------------------------

# Homebrew
if command -v brew > /dev/null ; then
    path_unshift "$(brew --prefix)/bin"
fi

# Heroku
path_unshift "$HOME/.local/heroku/bin"

# I like installing everything in ~/.local instead of /usr/local
path_unshift "$HOME/.local/bin"

# ----------------------------------------------------------------------
# Go Environment
# ----------------------------------------------------------------------

if [ -d "$HOME/.local/go" ]; then
    export GOROOT="$HOME/.local/go"
    path_push "$GOROOT/bin"
fi

if [ -d "$HOME/.go" ]; then
    export GOPATH="$HOME/.go"
    path_push "$GOPATH/bin"
fi

# ----------------------------------------------------------------------
# Ruby Environment (rbenv)
# ----------------------------------------------------------------------

if [ -d "$HOME/.rbenv" ]; then
    path_unshift "$HOME/.rbenv/bin"
    eval "$(rbenv init -)"
fi

# ----------------------------------------------------------------------
# Node Environment (nvm)
# ----------------------------------------------------------------------

if [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
    source $NVM_DIR/nvm.sh
    [[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion
fi

# ----------------------------------------------------------------------
# Python Environment
# ----------------------------------------------------------------------

if [ -e "$HOME/.local/bin/virtualenvwrapper.sh" ]; then
    [ -d "$HOME/.virtualenvs" ] || mkdir -p $HOME/.virtualenvs
    export WORKON_HOME=$HOME/.virtualenvs
    source $HOME/.local/bin/virtualenvwrapper.sh
    export VIRTUALENV_USE_DISTRIBUTE=true
    export PIP_VIRTUALENV_BASE=$WORKON_HOME
    export PIP_REQUIRE_VIRTUALENV=false
    export PIP_RESPECT_VIRTUALENV=true
    export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
    export VIRTUAL_ENV_DISABLE_PROMPT=true
fi
