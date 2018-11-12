source ~/.zsh_plugins.sh

# setup for fzf
if [[ ! -d ~/.fzf ]]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# aliases
alias -- -='cd -'
alias ...='../../'
alias ....='../../../'
alias .....='../../../../'
alias ......='../../../../../'

alias la='ls -Ah'
alias ll='ls -lh'
alias ls='ls --color=auto'

alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color'

alias cp='cp -i'
alias rm='rm -i'

# load .bash_profile
if [ -f ~/.bash_profile ]; then
  source ~/.bash_profile
fi

