#!/bin/sh

# setup for Cask
curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python

# setup for vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# setup for Rust
curl https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env
rustup component add rustfmt-preview

# setup for ac-php
sudo apt update
sudo apt install php-cli cscope
