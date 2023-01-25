#!/usr/bin/env bash

set -Eeuo pipefail

function is_omf_exists() {
    test -d ~/.local/share/omf &>/dev/null
}

function install_omf() {
    if ! is_omf_exists; then
        curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install > /tmp/install
        fish /tmp/install --path=~/.local/share/omf --config=~/.config/fish/omf --noninteractive -y
        rm /tmp/install ~/.config/fish/conf.d/omf.fish
    fi
}

function main() {
    install_omf
}

if [ ${#BASH_SOURCE[@]} = 1 ]; then
    main
fi
