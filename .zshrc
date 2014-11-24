ZSH=/usr/share/oh-my-zsh/
ZSH_CUSTOM=~/.zsh/

ZSH_THEME="lambda-17"

CASE_SENSITIVE="true"

DISABLE_AUTO_UPDATE="true"

DISABLE_AUTO_TITLE="true"

COMPLETION_WAITING_DOTS="true"

plugins=(git history-substring-search)

source $ZSH/oh-my-zsh.sh

unsetopt correct
unsetopt correct_all
unsetopt extended_glob

source ~/.zprofile

source $ZSH_CUSTOM/prompt.sh
source $ZSH_CUSTOM/aliases.sh

if [ "$BACKGROUND" ]; then
    eval `dircolors ~/.dircolors.$BACKGROUND`
    export TERM=rxvt-unicode-256color
fi
