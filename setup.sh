#!/bin/sh

# setup for Cask
curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python

# setup for dein.vim
mkdir -p ~/.vim/dein/repos/github.com/Shougo/dein.vim
git clone https://github.com/Shougo/dein.vim.git ~/.vim/dein/repos/github.com/Shougo/dein.vim

# setup for ac-php
sudo apt update
sudo apt install php-cli cscope
