# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

# Essential
source ~/.zplug/init.zsh

# Make sure to use double quotes to prevent shell expansion
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# Add a bunch more of your favorite packages!
zplug "zplug/zplug"
zplug "djui/alias-tips"
zplug "b4b4r07/enhancd"
zplug "yous/vanilli.sh"
zplug "hlissner/zsh-autopair"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "joel-porquet/zsh-dircolors-solarized", hook-load:setupsolarized
zplug "zsh-users/zsh-history-substring-search"

zplug "plugins/git", from:oh-my-zsh

# Load theme file
zplug 'dracula/zsh', as:theme

# Install packages that have not been installed yet
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  else
    echo
  fi
fi

zplug load

# aliases
alias -- -='cd -'
alias ...='../../'
alias ....='../../../'
alias .....='../../../../'
alias ......='../../../../../'

alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls --color=auto'

alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color'

# load .bash_profile
if [ -f ~/.bash_profile ]; then
  source ~/.bash_profile
fi
