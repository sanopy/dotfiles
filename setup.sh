#!/bin/sh

# setup for Cask
curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python

# setup for dein.vim
mkdir -p ~/.vim/dein
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh | sh -s ~/.vim/dein

# setup for Rust
curl https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env
rustup component add rustfmt-preview

# setup for ac-php
sudo apt update
sudo apt install php-cli cscope
