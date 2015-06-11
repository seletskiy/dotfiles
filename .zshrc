unsetopt correct
unsetopt correct_all
unsetopt global_rcs

source /usr/share/zsh/scripts/antigen/antigen.zsh

antigen bundle kovetskiy/zsh-add-params
    bindkey -v '^K' add-params

antigen bundle kovetskiy/zsh-fastcd

antigen use prezto

antigen apply

source ~/.zprofile

source ~/.zsh/aliases.sh

export ZDOTDIR=~

if [ "$BACKGROUND" ]; then
    eval `dircolors ~/.dircolors.$BACKGROUND`
    export TERM=rxvt-unicode-256color
fi
