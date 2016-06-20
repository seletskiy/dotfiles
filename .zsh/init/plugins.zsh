ZGEN_DIR=$ZDOTDIR/.zgen/

# unless, zsh will crash with core dumped
if ! type zgen >/dev/null 2>&1; then
    source /usr/share/zsh/scripts/zgen/zgen.zsh
fi

zle() {
    if [ "$1" = "-R" ]; then
        unset -f zle

        :load:plugins

        clear
    fi

    builtin zle "${@}"
}

:load:plugins() {
    zgen load kovetskiy/zsh-add-params
    zgen load kovetskiy/zsh-quotes
    zgen load kovetskiy/zsh-smart-ssh
    zgen load seletskiy/zsh-ssh-urxvt
    zgen load seletskiy/zsh-ash-completion
    zgen load seletskiy/zsh-context-aliases
    zgen load seletskiy/zsh-git-smart-commands
    zgen load seletskiy/zsh-smart-kill-word
    zgen load seletskiy/zsh-hijack
    zgen load seletskiy/zsh-hash-aliases

    zgen load seletskiy/zsh-uber-ssh
    zgen load seletskiy/zsh-favorite-directories

    zgen load hlissner/zsh-autopair autopair.zsh

    zgen load knu/zsh-manydots-magic

    zgen load deadcrew/deadfiles
    zgen load seletskiy/zsh-syntax-highlighting

    # must be last!
    zgen load seletskiy/zsh-autosuggestions

    fpath=(${ZGEN_COMPLETIONS[@]} $fpath)

    source $ZDOTDIR/aliases/hijack.zsh
    source $ZDOTDIR/aliases/context/_all.zsh

    source $ZDOTDIR/post-init/autopair.zsh
    source $ZDOTDIR/post-init/opts.zsh
    source $ZDOTDIR/post-init/fzf.zsh
    source $ZDOTDIR/post-init/autosuggest.zsh
    source $ZDOTDIR/post-init/smart-kill-word.zsh
    source $ZDOTDIR/post-init/manydots-magic.zsh
    source $ZDOTDIR/post-init/smart-ssh.zsh
    source $ZDOTDIR/post-init/hash-aliases.zsh
    source $ZDOTDIR/post-init/context-aliases.zsh
    source $ZDOTDIR/post-init/favorite-directories.zsh

    compinit
}

if ! zgen saved; then
    zgen load seletskiy/zsh-zgen-compinit-tweak
    zgen load sorin-ionescu/prezto
    zgen load mafredri/zsh-async
    zgen load seletskiy/zsh-fuzzy-search-and-edit
    zgen load seletskiy/zsh-prompt-lambda17

    zgen save

    zgen init
fi
