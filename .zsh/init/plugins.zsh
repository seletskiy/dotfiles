ZGEN_DIR=$ZDOTDIR/.zgen/

# unless, zsh will crash with core dumped
if ! type zgen >/dev/null 2>&1; then
    source /usr/share/zsh/scripts/zgen/zgen.zsh
fi


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
    zgen load supercrabtree/k

    zgen load zsh-users/zsh-syntax-highlighting

    # must be last!
    zgen load zsh-users/zsh-autosuggestions

    zgen save

    if [ "$ZGEN_RECURSE" ]; then
        echo Found recursion loop at loading zgen plugins.
        exit 1
    else
        ZGEN_RECURSE=1 source ~/.zshrc
    fi
fi
