unalias -m '*'

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
alias gplo='git pull --rebase && git push'
alias gcl='git clone'
alias gst='git stash'
alias grc='git rebase --continue'
alias gra='git rebase --abort'
alias gstd='git stash -u && git stash drop'
alias gco='git checkout'
alias gb='git branch'
alias grh='git reset HEAD'
alias gi='git add -pi'

alias srm='ssh-keygen -R'

alias -g L='| less'
alias -g G='| grep'
alias -g T='| tail'
alias -g F='| tail -f'
alias -g X='| xclip'
alias -g N1='| tail -n1'
alias -g R='| xargs -n1'

alias w1='watch -n1 '
alias sctl='sudo systemctl'

alias ipa='ip a'

alias vim='vim --servername vim'

alias d='dirs -v'
alias dt='cd ~/sources/dotfiles'

alias p='pacman'
alias pp='sudo pacman -S'

for index ({1..9}) alias "$index=cd +${index}"; unset index
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

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
    local reponame="$1" ; shift
    local clone_path="${1:-$reponame}"

    git clone gh:seletskiy/$reponame ~/sources/$clone_path
    cd ~/sources/$clone_path
}

alias gclg='git-clone-github'
function git-clone-github() {
    local reponame="$1"
    local dirname="${2:-${reponame#*/}}"

    git clone gh:$reponame ~/sources/$dirname
    cd ~/sources/$dirname
}


alias grem='git-remote-add-me'
function git-remote-add-me() {
    local reponame="$1"; shift

    git remote add seletskiy gh:seletskiy/$reponame "${@}"
}

# in case of servers that are know nothing about rxvt-unicode-256color
# better ssh="TERM=xterm ssh" alias
alias ssh='ssh-urxvt'
function ssh-urxvt() {
    # in case of stdin, stdout or stderr is not a terminal, fallback to ssh
    if [[ ! ( -t 0 && -t 1 && -t 2 ) ]]; then
        \ssh "$@"
    fi

    # if there more than one arg (hostname) without dash "-", fallback to ssh
    local hostname=''
    for arg in "$@"; do
        if [ ${arg:0:1} != - ]; then
            if [[ -n $hostname ]]; then
                \ssh "$@"
            fi
            hostname=$arg
        fi
    done

    # check terminal is known, if not, fallback to xterm
    \ssh -t "$@" "infocmp >/dev/null 2>&1 || export TERM=xterm; LANG=$LANG \$SHELL"
}

alias mgp='move-to-gopath'
function move-to-gopath() {
    local directory=${1:-.}
    local site=${2:-github.com}
    local remote=${3:-origin}

    directory=$(readlink -f .)
    cd $directory

    local repo_path=$(git remote show $remote -n | awk '/Fetch URL/{print $3}' | cut -f2 -d:)
    local target_path=$GOPATH/src/$site/$repo_path

    mkdir -p $(dirname $target_path)

    mv $directory $target_path

    ln -sf $target_path $directory

    cd $directory
}
