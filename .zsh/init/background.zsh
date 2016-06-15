if [ "$BACKGROUND" ]; then
    eval `dircolors ~/.dircolors.$BACKGROUND`
    if [ "$TMUX" ]; then
        export TERM=screen-256color
    fi
fi
