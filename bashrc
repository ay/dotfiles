#!/usr/bin/env bash
#
# Alex Yakoubian's .bashrc

: ${UNAME=$(uname)}

# ----------------------------------------------------------------------
# Shell Options
# ----------------------------------------------------------------------

# Wrap lines correctly after resizing window
shopt -s checkwinsize

# Save a limited history
export HISTSIZE=500

# Don't save history if command starts with a space
export HISTCONTROL="ignorespace"

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
elif ls -G > /dev/null 2>&1; then  # BSD ls (except OpenBSD)
    alias ls="ls -G"
fi

# Colorful grep
if grep --color "a" <<< "a" > /dev/null 2>&1; then
    alias grep="grep --color=auto"
    alias fgrep="fgrep --color=auto"
    alias egrep="egrep --color=auto"
fi

# terminfo/termcap compatibility
TERM_COLORS="$( { tput Co || tput colors ; } 2>/dev/null )"
if tput setaf 0 >/dev/null 2>&1 ; then
    # GNU/Linux and OS X
    term_setaf () { tput setaf "$1" ; }
elif tput AF 0 >/dev/null 2>&1 ; then
    # FreeBSD
    term_setaf () { tput AF "$1" ; }
fi

# Initialize colors from Solarized color scheme. Color names and values from
# http://ethanschoonover.com/solarized#the-values
if declare -F term_setaf &>/dev/null; then
    if [[ $TERM_COLORS -ge 256 ]]; then
        BASE03="\[$(term_setaf 234)\]"
        BASE02="\[$(term_setaf 235)\]"
        BASE01="\[$(term_setaf 240)\]"
        BASE00="\[$(term_setaf 241)\]"
        BASE0="\[$(term_setaf 244)\]"
        BASE1="\[$(term_setaf 245)\]"
        BASE2="\[$(term_setaf 254)\]"
        BASE3="\[$(term_setaf 230)\]"
        YELLOW="\[$(term_setaf 136)\]"
        ORANGE="\[$(term_setaf 166)\]"
        RED="\[$(term_setaf 160)\]"
        MAGENTA="\[$(term_setaf 125)\]"
        VIOLET="\[$(term_setaf 61)\]"
        BLUE="\[$(term_setaf 33)\]"
        CYAN="\[$(term_setaf 37)\]"
        GREEN="\[$(term_setaf 64)\]"
    else
        BASE03="\[$(term_setaf 8)\]"
        BASE02="\[$(term_setaf 0)\]"
        BASE01="\[$(term_setaf 10)\]"
        BASE00="\[$(term_setaf 11)\]"
        BASE0="\[$(term_setaf 12)\]"
        BASE1="\[$(term_setaf 14)\]"
        BASE2="\[$(term_setaf 7)\]"
        BASE3="\[$(term_setaf 15)\]"
        YELLOW="\[$(term_setaf 3)\]"
        ORANGE="\[$(term_setaf 9)\]"
        RED="\[$(term_setaf 1)\]"
        MAGENTA="\[$(term_setaf 5)\]"
        VIOLET="\[$(term_setaf 13)\]"
        BLUE="\[$(term_setaf 4)\]"
        CYAN="\[$(term_setaf 6)\]"
        GREEN="\[$(term_setaf 2)\]"
    fi
    BOLD="\[$( { tput bold || tput md ; } 2>/dev/null )\]"
    RESET="\[$( { tput sgr0 || tput me ; } 2>/dev/null )\]"
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
    local git_status="$(git status 2> /dev/null | tail -n1)"
    [[ $git_status != *"working directory clean"* && $git_status != *"working tree clean"* ]] && echo "*"
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

# Don't show hostname in prompt if the terminal is local
if [ -z "$TERM_PROGRAM" ]; then
    PS1="${COLOR1}\u${BASE0}@${COLOR2}\h${BASE0}:${COLOR3}\w${CYAN}\$(_parse_git_branch)${COLOR4}$P${RESET} "
else
    PS1="${COLOR3}\w${CYAN}\$(_parse_git_branch)${COLOR4}$P${RESET} "
fi
PS2="> "

# ----------------------------------------------------------------------
# Editor and Pager
# ----------------------------------------------------------------------

if command -v vim > /dev/null ; then
    export EDITOR="vim"
    export VISUAL="vim"
fi

export PAGER="less -FiRS"

# ----------------------------------------------------------------------
# Shell configuration
# ----------------------------------------------------------------------

if [ -d "$HOME/.profile.d" ]; then
    for i in "$HOME"/.profile.d/*.sh; do
        if [ -r $i ]; then
            source $i
        fi
    done
fi
