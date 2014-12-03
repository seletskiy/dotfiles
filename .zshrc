unsetopt correct
unsetopt correct_all
#unsetopt extended_glob

source ~/.zprofile

#source ~/.zsh/prompt.sh
source ~/.zsh/aliases.sh

if [ "$BACKGROUND" ]; then
    eval `dircolors ~/.dircolors.$BACKGROUND`
    export TERM=rxvt-unicode-256color
fi
