unsetopt correct
unsetopt correct_all

source ~/.zprofile

source ~/.zsh/aliases.sh

if [ "$BACKGROUND" ]; then
    eval `dircolors ~/.dircolors.$BACKGROUND`
    export TERM=rxvt-unicode-256color
fi
