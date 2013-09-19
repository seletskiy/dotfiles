unalias _

alias ssh='TERM=xterm ssh'

alias gdc='git diff --cached'
alias gss='git status -s'
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

zle -N prepend-sudo prepend_sudo
bindkey "^S" prepend-sudo
function prepend_sudo() {
    BUFFER="sudo "$BUFFER
    CURSOR=$(($CURSOR+5))
}
