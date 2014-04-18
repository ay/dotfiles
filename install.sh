#!/usr/bin/env bash
#
# Much taken from Carl Jackson's install.sh:
# https://github.com/zenazn/dotfiles/blob/master/install.sh

ROOT=$(cd "$(dirname "$0")" && pwd)

_green () { printf "\033[32m$1\033[0m\n"; }
_yellow () { printf "\033[33m$1\033[0m\n"; }
_red () { printf "\033[31m$1\033[0m\n"; }

_link () {
    local from="$1" to="$2" from_="$ROOT/$1" to_="$HOME/$2"
    _yellow "Linking ~/$to => $from"
    if [ -d "$from_" ]; then
        ln -s "$from_/" "$to_"
    else
        ln -s "$from_" "$to_"
    fi
}

# Install a file or directory to a given path by symlinking it, printing nice
# things along the way.
_install () {
    local from="$1" to="$2" from_="$ROOT/$1" to_="$HOME/$2"

    if [ ! -e "$from_" ]; then
        _red "ERROR: $from doesn't exist! This is an error in $0"
        return 1
    fi

    if [ ! -e "$to_" ]; then
        _link "$from" "$to"
    else
        local link
        link=$(readlink "$to_")
        if [ "$?" == 0 -a \( "$link" == "$from_" -o "$link" == "$from_/" \) ]; then
            _green "Link ~/$to => $from already exists!"
        else
            if _ask "~/$to already exists. Would you like to replace it"; then
                _yellow "Moving ~/$to to ~/${to}.old"
                mv "$to_" "${to_}.old"
                _link "$from" "$to"
            else
                _red "Error linking ~/$to to $from: $to already exists!"
            fi
        fi
    fi
}

_install_dot () {
    _install "$1" ".$1"
}

_ask () {
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

_install_dot "bash_profile"
_install_dot "bashrc"
_install_dot "vimrc"
_install_dot "vim"
_install_dot "gitconfig"
_install_dot "gitignore"
_install_dot "tmux.conf"
_install_dot "gemrc"

if ! git config --get-regexp submodule* > /dev/null; then
    if _ask "Initialize submodules" "Y"; then
        git submodule init
        git submodule update
    fi
fi

if command -v vim > /dev/null ; then
    if _ask "Install Vundle for Vim" "Y"; then
        vim +BundleInstall +qall
    fi
else
    _red "Error installing Vundle: Vim is not installed!"
fi

_green "All done! You might still have to do some stuff for everything to work properly:

    - Install a Powerline-patched font on your system and set it as the font
      on your terminal emulator. This is needed to work with vim-airline.

    - Install Ag (the_silver_searcher) so :Ag works in Vim.

    - It's probably a good idea to change your terminal emulator's color
      scheme to Solarized Dark (http://ethanschoonover.com/solarized)

    - If this is a workstation, generate (or import) an SSH keypair with
      \`ssh-keygen -t rsa -b 4096 -C alex@$(hostname)\`

    - If you're going to be SSHing into this machine, copy the public keys of
      all authorized users to ~/.ssh/authorized_keys

    - If you manually created ~/.ssh, make sure you chmod it to 700

    - If you plan on signing Git commits with your GPG key, be sure to install
      GPG and import your keys\n"
