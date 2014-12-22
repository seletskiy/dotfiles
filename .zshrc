unsetopt correct
unsetopt correct_all
unsetopt global_rcs

source ~/.zprofile

source ~/.zsh/aliases.sh

if [ "$BACKGROUND" ]; then
    eval `dircolors ~/.dircolors.$BACKGROUND`
    export TERM=rxvt-unicode-256color
fi
