# vim: ft=zsh

unalias -m '*'

alias l='ls'
alias ls='ls --color=always'
alias ll='ls -al'
alias li='\k'
alias lt='ls -alt'

alias g='git'
alias gi='git init'

alias srm='ssh-keygen -R'

alias w1='watch -n1 '

alias -- +='systemctl --user'
alias -- +R='+ daemon-reload'
alias -- +r='+R && systemctl-command-and-status --user restart'
function systemctl-command-and-status() {
    systemctl $1 $2 "$3"
    systemctl $1 status "$3"
}
compdef systemctl-command-and-status=systemctl

alias -- +s='+ status'
alias -- +t='+ stop'
alias -- +e='+ enable'
alias -- +E='+ reenable'
alias -- +d='+ disable'
alias -- +uf='+ list-unit-files'
alias -- +ld='+ list-dependencies'

alias jf='sudo journalctl -ef'

alias ag='ag -f'
alias f='find-alias'
function find-alias() {
    find -iname "*$1*"
}

alias ipa='ip a'

alias vf='vim $(fzf)'

alias d='dirs -v'
alias dt='cd ~/sources/dotfiles && git status -s'
alias kb='cd ~/sources/kb'

alias p='pacman'
alias pp='sudo pacman -S'
alias ppy='sudo pacman -Sy'
alias ppr='sudo pacman -R'
alias pqo='sudo pacman -Qo'
alias pql='sudo pacman -Ql'
alias pqi='sudo pacman -Qi'
alias ppu='sudo pacman -U'
alias pps='sudo pacman -Ss'

alias asp='ASPROOT=~/sources/asp asp'

alias run-help='man'

alias psx='ps axfu'

alias al='alias | grep'

alias ma='mplayer -novideo'
alias yt='youtube-viewer -n'

alias goi='go install'
alias gob='go build'
alias gog='go get -u'

alias a='ash inbox'
alias ar='ash'

alias zr='. ~/.zshrc'
alias za='vim ~/.zsh/aliases/* && source ~/.zshrc'

for index ({1..9}) alias "$index=cd +${index}"; unset index

alias rf='rm -rf'

zstyle ':completion:*:approximate:::' max-errors 3 not-numeric

alias vd="fastcd ~/.vim/bundle/ 1"
alias gd="fastcd $GOPATH/src/ 3"
alias sd="fastcd ~/sources/ 1"
alias zd="fastcd $ZGEN_DIR 2"

alias rto='rtorrent "$(ls --color=never -t ~/downloads/*.torrent | head -n1)"'

alias t='t --task-dir ~/tasks --list tasks'
alias tf='t -f'

# 20.12.L -> ssh 192.168.20.12
# 20.12.P -> ssh 172.16.20.12
# t1.e    -> ssh ngs.ru.t1
# s.s     -> ssh s.s
# blah.ru -> ssh blah.ru
# node.p  -> ssh node.in.ngs.ru
# node.x  -> (resolve via search domain setting) ssh node
alias -s L='uber-ssh:alias -P 192.168. -R .L'
alias -s P='uber-ssh:alias -P 172.16.  -R .P'
alias -s e='uber-ssh:alias -P ngs.ru.  -R .e'
alias -s s='uber-ssh:alias'
alias -s ru='uber-ssh:alias'
alias -s p='uber-ssh:alias -A .in.ngs.ru -R .p'
alias -s x='uber-ssh:alias -R .x'

alias ssh='ssh-urxvt'

alias ck='mkdir-and-cd'
function mkdir-and-cd() {
    mkdir -p $1 && cd $1
}

alias cks='ck-source-dir'
function ck-source-dir() {
    ck "sources/$1" && gi
}

alias di='./dotfiles install'
alias db='dotfiles-bootstrap'
function dotfiles-bootstrap() {
    local url=$1
    if [ -z "$1" ]; then
        url=$(xclip -o)
    fi

    local dotfiles_path=~/sources/dotfiles

    if grep -E "^https?:" <<< "$url"; then
        echo "-        $url" \
            | tee -a $dotfiles_path/profiles.txt \
            | $dotfiles_path/bootstrap $DOTFILES_PROFILE
    else
        grep "${@}" $dotfiles_path/profiles.txt \
            | $dotfiles_path/bootstrap $DOTFILES_PROFILE

    fi
}

alias aur='dotfiles-bootstrap-aur -S'
function dotfiles-bootstrap-aur() {
    shift
    dotfiles-bootstrap https://aur.archlinux.org/packages/$1
}

compdef dotfiles-bootstrap-aur=yaourt

alias godoc='godoc-less'
function godoc-less() {
    \godoc -ex "${@}" | less -SX
}

export KEYTIMEOUT=1
bindkey -v

bindkey -v "^P" history-substring-search-up
bindkey -v "^N" history-substring-search-down
bindkey -v "^A" beginning-of-line
bindkey -v "^[OA" history-substring-search-up
bindkey -v "^[OB" history-substring-search-down
bindkey -v "^[[3~" delete-char
bindkey -v '^A' beginning-of-line
bindkey -v '^E' end-of-line
bindkey -a '^?' backward-delete-char
bindkey -a '^H' backward-delete-char
bindkey -v '^[[Z' reverse-menu-complete
bindkey -v '^[d' delete-word

bindkey -a '^[' vi-insert
bindkey -a '^[d' delete-word
bindkey '^[Od' backward-word
bindkey '^[Oc' forward-word
bindkey -a '^[Od' backward-word
bindkey -a '^[Oc' forward-word
bindkey '^[[5~' forward-word
bindkey '^[[6~' backward-word

bindkey -v '^K' add-params
bindkey -v '^_' insert-dot-dot-slash
bindkey -v '^O' toggle-quotes

bindkey -v '^ ' autosuggest-execute

bindkey '^W' smart-backward-kill-word
bindkey '^S' smart-forward-kill-word

hijack:transform 'sed -re "s/^p([0-9]+)/phpnode\1.x/"'
hijack:transform 'sed -re "s/^f([0-9]+)/frontend\1.x/"'
hijack:transform 'sed -re "s/^(ri|ya|fo)((no|pa|re|ci|vo|mu|xa|ze|bi|so)+)/\1\2.x/"'
hijack:transform 'sed -re "s/^([[:alnum:].-]+\\.x)(\s+me)/\1 -ls.seletskiy/"'
hijack:transform 'sed -re "s/^([[:alnum:].-]+\\.x)($|\s+[^-s][^lu])/\1 sudo -i\2/"'

zle -N prepend-sudo prepend_sudo
bindkey "^T" prepend-sudo
function prepend_sudo() {
    if grep -q '^sudo ' <<< "$BUFFER"; then
        CURSOR=$(($CURSOR-5))
        BUFFER=${BUFFER:5}
        return
    fi

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

alias -- +x='chmod-alias'
function chmod-alias() {
    if [ $# -eq 0 ]; then
        chmod +x $(fc -ln -1 | awk '{print $1}')
    else
        chmod +x "${@}"
    fi
}

bindkey "^F" leap-back
zle -N leap-back leap-back
function leap-back() {
    local dir=$(dirs -p | fzf)
    if [ "$dir" ]; then
        cd "$dir"
    fi

    zle reset-prompt
}

alias me='git-clone-me'
function git-clone-me() {
    local reponame="$1" ; shift
    local clone_path="${1:-$reponame}"

    git clone gh:seletskiy/$reponame ~/sources/$clone_path
    cd ~/sources/$clone_path
}

alias github='git-clone-github'
function git-clone-github() {
    local reponame="$1"
    local dirname="${2:-${reponame#*/}}"

    git clone gh:$reponame ~/sources/$dirname
    cd ~/sources/$dirname
}

alias kovetskiy='git-clone-github-kovetskiy'
function git-clone-github-kovetskiy() {
    local reponame="$1"
    local dirname="${2:-${reponame#*/}}"

    git clone gh:kovetskiy/$reponame ~/sources/$dirname
    cd ~/sources/$dirname
}

alias devops='git-clone-internal-devops'
function git-clone-internal-devops() {
    local reponame="$1"
    local dirname="${2:-${reponame#*/}}"

    git clone g:devops/$reponame ~/sources/$dirname
    cd ~/sources/$dirname
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

hash-aliases:install

autoload is_inside_git_repo
autoload is_git_repo_dirty
autoload is_rebase_in_progress

alias gc='git clone'

context-aliases:match is_inside_git_repo
    alias d='git diff'
    alias dd='git diff --cached'
    alias a='git-smart-add'
    alias a!='git-smart-commit -a --amend'
    alias s='git status -s'
    alias o='git log --oneline --graph --decorate --all'
    alias c='git-smart-commit --amend'
    alias ca='git-smart-commit -a'
    alias c!='git-smart-commit --amend'
    alias p='git-smart-push seletskiy'
    alias p!='git-smart-push seletskiy +`git symbolic-ref --short -q HEAD`'
    alias u='git-smart-pull --rebase'
    alias k='git checkout'
    alias km='git checkout master'
    alias kp='git checkout pkgbuild'
    alias r='git-smart-remote'
    alias rs='git-smart-remote show'
    alias rso='git-smart-remote show origin'
    alias ru='git-smart-remote set-url'
    alias e='git rebase'
    alias b='git branch'
    alias h='git reset HEAD'
    alias i='git add -p'
    alias st='git stash'
    alias std='git stash -u && git stash drop'
    alias lk='github-browse'

    function github-browse() {
        local file="$1"
        local line="${2:+#L$2}"

        local type=commit
        if [ "$file" ]; then
            type=blob
        fi

        hub browse -u -- $type/$(git rev-parse --short HEAD)/$file$line \
            2>/dev/null
    }

    alias aur='push-to-aur'

    function push-to-aur() {
        local package_name="${1:-$(basename $(git rev-parse --show-toplevel)-git)}"

        git push ssh://aur@aur.archlinux.org/$package_name pkgbuild:master
    }

    alias mm='git-merge-with-rebase'
    function git-merge-with-rebase() {
        local branch=$(git rev-parse --abbrev-ref HEAD)
        if git rebase "${@}"; then
            git checkout $branch
            git merge --no-ff "$branch" "${@}"
        fi
    }

    function _git-merge-with-rebase() {
        service="git-merge" _git "${@}"
    }

    compdef _git-merge-with-rebase git-merge-with-rebase

    alias me='git-remote-add-me'
    function git-remote-add-me() {
        if [ "$1" ]; then
            local reponame="$1"; shift
        else
            local reponame=$(git remote show origin -n | awk '/Fetch URL/{print $3}' | cut -f2 -d/)
            if [ "$reponame" = "origin" ]; then
                local reponame=$(basename $(pwd))
            fi
        fi

        if [ -z "$reponame" ]; then
            echo "no repo can be matched"
            return 1
        fi

        git remote add seletskiy gh:seletskiy/$reponame "${@}"
    }


context-aliases:match "is_inside_git_repo && is_git_repo_dirty"
    alias c='git-smart-commit'

context-aliases:match "is_inside_git_repo && is_rebase_in_progress"
    alias m='git checkout --ours'
    alias t='git checkout --theirs'
    alias c='git rebase --continue'
    alias b='git rebase --abort'
