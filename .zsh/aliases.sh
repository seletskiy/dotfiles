unalias _

alias ssh='TERM=xterm ssh'

alias gdc='git diff --cached'
alias gs='git status -s'
alias gl='git log --oneline --graph --decorate --all'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gc!='git commit --amend'
alias gcm!='git commit --amend -m'
alias gp='git push'
alias gpo='git push origin'
alias gr='git remote'
alias gres='git remote set-url'
alias gpl='git pull --rebase'
alias gcl='git clone'
alias gst='git stash'
alias grc='git rebase --continue'
alias gra='git rebase --abort'

alias -g L='| less'
alias -g G='| grep'

alias w1='watch -n1 '
alias sctl='sudo systemctl'

alias vim='vim --servername vim'

bindkey "^P" history-substring-search-up
bindkey "^N" history-substring-search-down

zle -N prepend-sudo prepend_sudo
bindkey "^T" prepend-sudo
function prepend_sudo() {
    if [ "$BUFFER" ]; then
        BUFFER="sudo "$BUFFER
    else
        BUFFER="sudo "$(fc -ln -1)
    fi
    CURSOR=$(($CURSOR+5))
}

autoload smart-insert-last-word
bindkey "\e." smart-insert-last-word-wrapper
bindkey "\e," smart-insert-prev-word
zle -N smart-insert-last-word-wrapper
zle -N smart-insert-prev-word
function smart-insert-last-word-wrapper() {
    _altdot_reset=1
    smart-insert-last-word
}
function smart-insert-prev-word() {
    if (( _altdot_reset )); then
        _altdot_histno=$HISTNO
        (( _altdot_line=-_ilw_count ))
        _altdot_reset=0
        _altdot_word=-2
    elif (( _altdot_histno != HISTNO || _ilw_cursor != $CURSOR )); then
        _altdot_histno=$HISTNO
        _altdot_word=-1
        _altdot_line=-1
    else
        _altdot_word=$((_altdot_word-1))
    fi

    smart-insert-last-word $_altdot_line $_altdot_word 1

    if [[ $? -gt 0 ]]; then
        _altdot_word=-1
        _altdot_line=$((_altdot_line-1))
        smart-insert-last-word $_altdot_line $_altdot_word 1
    fi
}

bindkey "^[[11^" noop
zle -N noop noop
function noop()  {
}

alias gclm='git-clone-me'
function git-clone-me() {
    reponame="$1" ; shift

    git clone gh:seletskiy/$reponame "${@}"
}
