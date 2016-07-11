favorite-directories:get() {
    echo sources 1 ~/sources
    echo zsh 2 ~/.zsh/.zgen
    echo vim 2 ~/.vim
    echo go 3 ~/.go/src
}

favorite-directories:on-cd() {
    context-aliases:on-precmd

    prompt_lambda17_precmd

    zle reset-prompt
}
