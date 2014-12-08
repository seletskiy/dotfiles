unalias -m '*'

#alias ssh='TERM=xterm ssh'

alias l='ls'
alias ls='ls --color=always'
alias g='git'
alias gd='git diff'
alias ga='git add'
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
alias gstd='git stash -u && git stash drop'

alias -g L='| less'
alias -g G='| grep'
alias -g T='| tail'
alias -g N1='| tail -n1'
alias -g X='| xclip'

alias w1='watch -n1 '
alias sctl='sudo systemctl'

alias vim='vim --servername vim'

export KEYTIMEOUT=1
bindkey -v

bindkey -v "^P" history-substring-search-up
bindkey -v "^N" history-substring-search-down
bindkey -v "^A" beginning-of-line
bindkey -v "$terminfo[kcuu1]" history-substring-search-up
bindkey -v "$terminfo[kcud1]" history-substring-search-down
bindkey -v "^R" history-incremental-search-backward
bindkey -v "$terminfo[kdch1]" delete-char
bindkey -v "^Q" push-line
bindkey -v '^A' beginning-of-line
bindkey -v '^E' end-of-line
bindkey -v '^?' backward-delete-char
bindkey -v '^H' backward-delete-char
bindkey -v '^W' backward-kill-word
bindkey -v '^K' vi-kill-eol
bindkey -v '^[[Z' reverse-menu-complete
bindkey -v '^[d' delete-word

bindkey -a '^[' vi-insert
bindkey -a '^[d' delete-word

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

alias grem='git-remote-add-me'
function git-remote-add-me() {
    reponame="$1"; shift

    git remote add seletskiy gh:seletskiy/$reponame "${@}"
}
