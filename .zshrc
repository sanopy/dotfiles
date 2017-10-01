# Check if Antigen is installed
if [[ ! -d ~/.antigen ]]; then
  git clone https://github.com/zsh-users/antigen.git ~/.antigen
fi

source ~/.antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
# antigen bundle heroku
# antigen bundle pip
# antigen bundle lein
antigen bundle command-not-found

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

antigen bundle djui/alias-tips
antigen bundle yous/vanilli.sh
antigen bundle rupa/z
antigen bundle hlissner/zsh-autopair
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle joel-porquet/zsh-dircolors-solarized
antigen bundle zsh-users/zsh-history-substring-search

# Load the theme.
# antigen theme robbyrussell
antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure

# Tell Antigen that you're done.
antigen apply

# setup for zsh-dircolors-solarized
setupsolarized

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

