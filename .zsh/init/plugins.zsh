ZGEN_DIR=$ZDOTDIR/.zgen/

source /usr/share/zsh/scripts/zgen/zgen.zsh

if ! zgen saved; then
    zgen load seletskiy/zsh-zgen-compinit-tweak

    zgen load sorin-ionescu/prezto

    zgen load kovetskiy/zsh-add-params
    zgen load kovetskiy/zsh-fastcd
    zgen load kovetskiy/zsh-quotes
    zgen load kovetskiy/zsh-smart-ssh
    zgen load kovetskiy/zsh-insert-dot-dot-slash
    zgen load seletskiy/zsh-ssh-urxvt
    zgen load seletskiy/zsh-prompt-lambda17
    zgen load seletskiy/zsh-ash-completion
    zgen load seletskiy/zsh-context-aliases
    zgen load seletskiy/zsh-git-smart-commands
    zgen load seletskiy/zsh-smart-kill-word
    zgen load seletskiy/zsh-hash-aliases
    zgen load seletskiy/zsh-hijack
    zgen load seletskiy/zsh-uber-ssh

    zgen load zsh-users/zsh-autosuggestions
    zgen load zsh-users/zsh-syntax-highlight

    zgen save
fi

