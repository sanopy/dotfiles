#!/bin/sh

# setup for Cask
curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python

# setup for neobundle
curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh

# setup for ac-php
sudo apt update
sudo apt install php-cli cscope
