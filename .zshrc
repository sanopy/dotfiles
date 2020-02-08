### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
        print -P "%F{160}▓▒░ The clone has failed.%f"
fi
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit installer's chunk

zinit ice wait'!0'
zinit snippet OMZ::plugins/git/git.plugin.zsh

zinit ice wait'!0'
zinit snippet OMZ::plugins/command-not-found/command-not-found.plugin.zsh

zinit ice wait'!0'
zinit light djui/alias-tips

zinit light zdharma/fast-syntax-highlighting

zinit light yous/vanilli.sh

zinit ice wait'!0'
zinit light rupa/z

zinit ice wait'!0'
zinit light hlissner/zsh-autopair

zinit light zsh-users/zsh-autosuggestions

zinit light zsh-users/zsh-completions

zinit ice wait'!0'
zinit light zsh-users/zsh-history-substring-search

zinit ice atclone"dircolors -b LS_COLORS > c.zsh" atpull'%atclone' pick"c.zsh" nocompile'!'
zinit light trapd00r/LS_COLORS

zinit light geometry-zsh/geometry

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

# alias ls='ls -GF'
alias ls='ls -F --color=auto'
alias la='ls -A'
alias ll='ls -lh'

alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color'

alias cp='cp -i'
alias rm='rm -i'

# load .bash_profile
if [ -f ~/.bash_profile ]; then
  source ~/.bash_profile
fi
