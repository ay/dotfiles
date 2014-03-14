#!/bin/bash
#
# Much taken from Carl Jackson's install.sh:
# https://github.com/zenazn/dotfiles/blob/master/install.sh

ROOT=$(cd "$(dirname "$0")" && pwd)

green () { printf "\033[32m$1\033[0m\n"; }
yellow () { printf "\033[33m$1\033[0m\n"; }
red () { printf "\033[31m$1\033[0m\n"; }

link () {
    local from="$1" to="$2" from_="$ROOT/$1" to_="$HOME/$2"
    yellow "Linking ~/$to => $from"
    if [ -d "$from_" ]; then
        ln -s "$from_/" "$to_"
    else
        ln -s "$from_" "$to_"
    fi
}

# Install a file or directory to a given path by symlinking it, printing nice
# things along the way.
install () {
    local from="$1" to="$2" from_="$ROOT/$1" to_="$HOME/$2"

    if [ ! -e "$from_" ]; then
        red "ERROR: $from doesn't exist! This is an error in $0"
        return 1
    fi

    if [ ! -e "$to_" ]; then
        link "$from" "$to"
    else
        local link
        link=$(readlink "$to_")
        if [ "$?" == 0 -a \( "$link" == "$from_" -o "$link" == "$from_/" \) ]; then
            green "Link ~/$to => $from already exists!"
        else
            if ask "~/$to already exists. Would you like to replace it"; then
                yellow "Moving ~/$to to ~/${to}.old"
                mv "$to_" "${to_}.old"
                link "$from" "$to"
            else
                red "Error linking ~/$to to $from: $to already exists!"
            fi
        fi
    fi
}

install_dot () {
    install "$1" ".$1"
}

ask () {
    local question="$1" default_y="$2" yn
    if [ -z "$default_y" ]; then
        read -p "$question [y/N]? "
    else
        read -p "$question [Y/n]? "
    fi
    yn=$(echo "$REPLY" | tr "A-Z" "a-z")
    if [ -z "$default_y" ]; then
        test "$yn" == 'y' -o "$yn" == 'yes'
    else
        test "$yn" != 'n' -a "$yn" != 'no'
    fi
}

install_dot "bash_profile"
install_dot "bashrc"
install_dot "vimrc"
install_dot "vim"
install_dot "gitconfig"
install_dot "gitignore"
install_dot "tmux.conf"
install_dot "gemrc"

if ! git config --get-regexp submodule* > /dev/null; then
    if ask "Initialize submodules" "Y"; then
        git submodule init
        git submodule update
    fi
fi

if command -v vim > /dev/null ; then
    if ask "Install Vundle for Vim" "Y"; then
        vim +BundleInstall +qall
    fi
else
    red "Error installing Vundle: Vim is not installed!"
fi

green "All done!"
