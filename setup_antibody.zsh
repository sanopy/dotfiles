#!/usr/bin/zsh

cd `dirname $0`

curl -sL git.io/antibody | sh -s - -b ~/.bin
antibody bundle < ./.zsh_plugins.txt > ~/.zsh_plugins.sh
source ~/.zsh_plugins.sh

# setup for zsh-dircolors-solarized
setupsolarized
