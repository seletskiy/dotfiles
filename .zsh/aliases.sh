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
alias grs='git remote set-url'
alias gpl='git pull --rebase'
alias gcl='git clone'

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
