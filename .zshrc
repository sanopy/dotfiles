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

# Load OMZ library and plugins
zinit wait is-snippet for \
    OMZP::docker-compose \
    OMZP::command-not-found \
    OMZL::git.zsh \
    OMZP::git \
    OMZL::history.zsh

# Load OMZ `_*` files
zinit wait is-snippet as"completion" for \
    OMZP::docker/_docker \
    OMZP::docker-compose/_docker-compose

zinit cdclear -q

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

zinit for \
    light-mode zdharma/fast-syntax-highlighting \
    light-mode yous/vanilli.sh \
    light-mode zsh-users/zsh-autosuggestions \
    light-mode zsh-users/zsh-completions

zinit wait for \
    light-mode djui/alias-tips \
    light-mode rupa/z \
    light-mode hlissner/zsh-autopair \
    light-mode zsh-users/zsh-history-substring-search

zinit ice atclone"dircolors -b LS_COLORS > c.zsh" atpull'%atclone' pick"c.zsh" nocompile'!'
zinit light trapd00r/LS_COLORS

# load theme
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
