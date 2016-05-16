# vim: ft=zsh

unalias -m '*'

alias v='vim'

alias l='ls'
alias ls='ls --color=always'
alias ll='ls -al'
alias li='\k'
alias lt='ls -alt'

alias z='zfs list'

alias g='git init'

alias R='ssh-keygen -R'

alias 1='watch -n1 '

alias i='imgurbash'

alias np=':carcosa-new-password'
:carcosa-new-password() {
    cd ~/.secrets && \
        pwgen 10 1\
            | tee /dev/stderr \
            | xclip -f \
            | carcosa -Ac "passwords/$1"
}

alias am='adb-push-music'
function adb-push-music() {
    local dir=$1

    adb push $dir /storage/sdcard1/Music/
    adb shell am broadcast -a android.intent.action.MEDIA_MOUNTED \
        -d file:///storage/sdcard1/
}

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
alias -- +l='+ list-unit-files'
alias -- +p='+ list-dependencies'

alias jf='sudo journalctl -ef'

alias ag='ag -f --hidden'
alias f='find-alias'
function find-alias() {
    find -iname "*$1*"
}

alias ipa='ip a'

alias vf='vim $(fzf)'
alias vw='vim $(which)'
function vim-which() {
    vim "$(which "$1")"
}

compdef vim-which=which

alias dt='cd ~/sources/dotfiles && git status -s'
alias de='cd ~/sources/dotfiles/.deadfiles && git status -s'
alias kb='cd ~/sources/kb'
alias se='cd ~/.secrets && carcosa -Lc'

alias pp='sudo pacman -S'
alias pp!='yes | sudo pacman --force --noconfirm -S'
alias ppy='sudo pacman -Sy'
alias ppr='sudo pacman -R'
alias pqo='pacman -Qo'
alias pql='pacman -Ql'
alias pqi='pacman -Qi'
alias ppu='sudo pacman -U'
alias pps='pacman -Ss'
alias po='pkgfile'

alias zgu='zgen update && zr'

alias asp='ASPROOT=~/sources/asp asp'

alias psx='ps axfu'
alias psg='psx | grep -P'

alias al='alias | grep -P'

alias ma='mplayer -novideo'
alias yt='youtube-viewer -n'

alias goi='go install'
alias gob='go build'
alias gog='go get -u'

alias wt='test-runner-watcher 3 -A'
alias wt10='test-runner-watcher 10 -A'
alias wT='test-runner-watcher 10 -O'
function test-runner-watcher() {
    local timeout="$1"
    local run_tests_args="$2"

    shift 2

    if [ $# -gt 1 ]; then
        watcher "${@}"
    else
        watcher -e close_write -w$timeout ".$1$" -- \
            ./run_tests.sh $run_tests_args
    fi
}

alias a='ash-inbox-or-review'

function ash-inbox-or-review() {
    if [ $# -gt 0 ]; then
        ash "${@}"
    else
        ash inbox
    fi
}

alias zr='. ~/.zshrc'
alias za='vim ~/.zsh/aliases/* && source ~/.zshrc'

for index ({1..9}) alias "$index=cd +${index}"; unset index

alias rf='rm -rf'

zstyle ':completion:*:approximate:::' max-errors 3 not-numeric

alias v.="fastcd ~/.vim/bundle/ 1"
alias g.="fastcd $GOPATH/src/ 3"
alias s.="fastcd ~/sources/ 1"
alias z.="fastcd $ZGEN_DIR 2"

alias rto='rtorrent "$(ls --color=never -t ~/downloads/*.torrent | head -n1)"'

alias cu='curl -LO'

alias t='t --task-dir ~/tasks --list tasks'
alias tf='t -f'

# 20.12.L -> ssh 192.168.20.12
# 20.12.P -> ssh 172.16.20.12
# t1.e    -> ssh ngs.ru.t1
# s.s     -> ssh s.s
# blah.ru -> ssh blah.ru
# node.p  -> ssh node.in.ngs.ru
# node.x  -> (resolve via search domain setting) ssh node
alias -s  L='uber-ssh:alias -s smart-ssh -P 192.168.   -R .L'
alias -s  P='uber-ssh:alias -s smart-ssh -P 172.16.    -R .P'
alias -s  e='uber-ssh:alias -s smart-ssh -P ngs.ru.    -R .e'
alias -s  p='uber-ssh:alias -s smart-ssh -A .in.ngs.ru -R .p'
alias -s  x='uber-ssh:alias -s smart-ssh -R .x'
alias -s  s='uber-ssh:alias -s smart-ssh'
alias -s ru='uber-ssh:alias -s smart-ssh'

alias ssh='ssh-urxvt'
alias s='ssh'

function search-domain() {
    local domain=$1
    local resolver_host=$2
    local resolver_port=${3:-53}

    dig @$resolver_host -p$resolver_port axfr s \
        | awk '{print $1}' \
        | grep -P "$domain"
}

DNS_RESOLVER_HOST=dn.s
DNS_RESOLVER_PORT=53000
function search-domain-default() {
    search-domain "$1" $DNS_RESOLVER_HOST $DNS_RESOLVER_PORT
}


alias dbfs='ssh-multi -A -- $(search-domain-default "^db..farm") -'
alias yrds='ssh-multi -A -- $(search-domain-default "^ya.*yard.s") -'

alias frts='ssh-multi -A -- $(search-domain-default "^fo.*fortres.s") -'
alias phps='ssh-multi -A -- $(search-domain-default "^phpnode") -'
alias fros='ssh-multi -A -- $(search-domain-default "^frontend") -'
alias dbns='ssh-multi -A -- $(search-domain-default "^dbnode") -'
alias sphs='ssh-multi -A -- $(search-domain-default "search.common") -'
alias n1es='ssh-multi -A -- $(search-domain-default "elasticsearch.n1") -'
alias gees='ssh-multi -A -- $(search-domain-default "elasticsearch.geo") -'
alias aues='ssh-multi -A -- $(search-domain-default "elasticsearch.auto") -'
alias raes='ssh-multi -A -- $(search-domain-default "^rabota-es") -'

alias ck='mkdir-and-cd'
function mkdir-and-cd() {
    mkdir -p $1 && cd $1
}

alias cks='ck-source-dir'
function ck-source-dir() {
    ck ~/sources/"$1" && gi
}

DOTFILES_PATH=~/sources/dotfiles

alias di!="cd $DOTFILES_PATH && git-smart-pull && \
    ./bootstrap"
alias du!="di! $DOTFILES_PROFILE"
alias di="cd $DOTFILES_PATH && ./dotfiles install"
alias db='dotfiles-bootstrap'
function dotfiles-bootstrap() {
    local url=$1
    if [ -z "$1" ]; then
        url=$(xclip -o)
    fi

    if grep -P "^https?:" <<< "$url"; then
        local line="-        $url"
        $DOTFILES_PATH/bootstrap $DOTFILES_PROFILE <<< "$line"
        if [ $? -eq 0 ]; then
            echo "$line" >> $DOTFILES_PATH/profiles.txt
            return 1
        fi
    else
        grep "${@}" $DOTFILES_PATH/profiles.txt \
            | $DOTFILES_PATH/bootstrap $DOTFILES_PROFILE

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

alias man='man-search'

function man-search() {
    if grep -qoP '^\d+$' <<< "$1"; then
        MANSECT=$1 man-search $2 ${@:3}
        return
    fi

    if ! command man -w "$1" 2>/dev/null >/dev/null; then
        return 1
    fi

    if [ $# -gt 1 ]; then
        case "$2" in
            # common search mode
            /*)
                command vim -u ~/.vimrc-economy \
                    +"set noignorecase" +"Man $1" +only +"/${2:1}"
                return
                ;;
            # search for flags description
            -*)
                command vim -u ~/.vimrc-economy \
                    +"set noignorecase" +"Man $1" +only +"/^\\s\\+\\zs${2}"
                return
                ;;
            # search for subcommand definition
            .*)
                command vim -u ~/.vimrc-economy \
                    +"set noignorecase" \
                    +"Man $1" \
                    +only \
                    +"/\\n\\n^       \\zs${2:1}\\ze\( \|$\)"
                return
                ;;
            *)
                man-search "$1-$2" ${@:3}

                return
                ;;
        esac
    fi

    command vim -u ~/.vimrc-economy +"Man $MANSECT ${@}" +only
}

compdef man-search=man

export KEYTIMEOUT=1
bindkey -v

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

bindkey '^P' fuzzy-search-and-edit

zle -N fuzzy-search-and-edit
function fuzzy-search-and-edit() {
    local match=$(command ag -al 2>/dev/null \
        | xargs -n1 cat -n 2>/dev/null \
        | fzf -1)

    local files=(
        $(ag -Fl -- "$(cut -f 2- <<< "$match")" | sort | uniq 2>/dev/null)
    )

    if [ ${#files[@]} -gt 0 ]; then
        # /dev/tty required to redirect terminal from zle
        $EDITOR -o "${files[@]}" +$(awk '{print $1}' <<< "$match") < /dev/tty
    fi

    zle -I
}

hijack:reset
hijack:transform 'sed -re "s/^p([0-9]+)/phpnode\1.x/"'
hijack:transform 'sed -re "s/^f([0-9]+)/frontend\1.x/"'
hijack:transform 'sed -re "s/^(ri|ya|fo)((no|pa|re|ci|vo|mu|xa|ze|bi|so)+)(\s|$)/\1\2.x\4/"'
hijack:transform 'sed -re "s/^([[:alnum:].-]+\\.x)(\s+me)/\1 -ls.seletskiy/"'
hijack:transform 'sed -re "s/^([[:alnum:].-]+\\.x)($|\s+[^-s][^lu])/\1 sudo -i\2/"'
hijack:transform 'sed -re "s/^(\w{1,3}) ! /\1! /"'

hijack:transform 'sed -re "s/(\w+)( .*)!$/\1!\2/"'

hijack:transform '^[ct]!? ' 'sed -r s"/([<>{}&\\\"([!?)''^])/\\\\\1/g"'
hijack:transform 'sed -re "s/^c\\\! /c! /"'

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
        eval cd "$dir"
    fi

    zle reset-prompt
}

function git-clone-to-sources() {
    local who=$1
    local reponame="$2" ; shift
    local clone_path="${2:-$reponame}"

    git clone $who/$reponame ~/sources/$clone_path
    cd ~/sources/$clone_path
}

alias m='git-clone-to-sources gh:seletskiy'
alias k='git-clone-to-sources gh:kovetskiy'
alias r='git-clone-to-sources gh:reconquest'
alias d='git-clone-to-sources g:devops'
alias n='git-clone-to-sources g:ngs'

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

alias cr='create-new-project github'
function create-new-project() {
    local where=$1
    local project=$2

    local namespace=""
    if [ "${project##*/}" != "$project" ]; then
        local namespace=${project%%/*}/
        local project=${project##*/}
    fi

    cks $project
    case "$where" in
        g)
            hub create $namespace$project
            ;;
        r)
            hub create reconquest/$namespace$project
            ;;
        m)
            hub create seletskiy/$namespace$project
            ;;
    esac
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
    alias up='u && p'
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
    alias R='git rm'
    alias R!='git rm -f'
    alias st='git stash'
    alias std='git stash -u && git stash drop'
    alias fk='hub fork'
    alias pr='hub pull-request'
    alias lk='github-browse'
    alias g='cd-pkgbuild'

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
            local reponame=$(git remote show origin -n | awk '/Fetch URL/{print $3}')
            reponame=${reponame##*/}
        fi

        if [ -z "$reponame" ]; then
            echo "no repo can be matched"
            return 1
        fi

        git remote add seletskiy gh:seletskiy/$reponame "${@}"
    }


context-aliases:match "test -e PKGBUILD"

    alias g='go-makepkg-enhanced'
    alias m='makepkg -f'

    alias aur='push-to-aur'

    function push-to-aur() {
        local package_name="${1:-$(basename $(git rev-parse --show-toplevel))}"
        local package_name=${package_name%*-pkgbuild}
        local package_name=${package_name}-git

        git push ssh://aur@aur.archlinux.org/$package_name pkgbuild:master
    }

context-aliases:match "is_inside_git_repo && is_git_repo_dirty"
    alias c='git-smart-commit'

context-aliases:match "is_inside_git_repo && is_rebase_in_progress"
    alias m='git checkout --ours'
    alias t='git checkout --theirs'
    alias c='git rebase --continue'
    alias b='git rebase --abort'

context-aliases:match "is_inside_git_repo && \
        [ \"\$(git log 2>/dev/null | wc -l)\" -eq 0 ]"

    alias c='git add . && git commit -m "initial commit"'

context-aliases:match '[ "$(pwd)" = ~/.secrets ]'
    alias u='carcosa -Sn'
