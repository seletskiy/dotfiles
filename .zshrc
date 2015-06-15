zmodload zsh/zprof

# wow, such integration! https://github.com/tarjoilija/zgen/pull/27
ln -sf ~/.zgen/sorin-ionescu/prezto-master ~/.zprezto

alias compinit='my-compinit'
function my-compinit() { grep -q ".zgen" <<< "${@}" || \compinit "${@}" }

source /usr/share/zsh/scripts/zgen/zgen.zsh

unalias compinit

if ! zgen saved; then
    zgen load sorin-ionescu/prezto

    zgen load kovetskiy/zsh-add-params
    zgen load kovetskiy/zsh-fastcd
    zgen load seletskiy/zsh-ssh-urxvt
    zgen load seletskiy/zsh-prompt-lambda17

    zgen save
fi

unsetopt correct
unsetopt correct_all
unsetopt global_rcs

setopt menu_complete

source ~/.zprofile
source ~/.zaliases

source /usr/share/zsh/functions/Prompts/promptinit
promptinit

prompt lambda17 white red λ

if [ "$BACKGROUND" ]; then
    eval `dircolors ~/.dircolors.$BACKGROUND`
    export TERM=rxvt-unicode-256color
    if [ "$TMUX" ]; then
        export TERM=screen-256color-so
    fi
fi
