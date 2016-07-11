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

alias skr='ssh-keygen -R'

alias 1='watch -n1 '

alias i='imgur.sh'

alias bl='batrak -L'
alias bd='batrak -M 21 -n'
alias bp='batrak -Lf 16058'

alias fin='get-stock ABBV MSFT TSLA TWTR'

alias lgs=':git:show-sources-status'
:git:show-sources-status() {
    lsgs -Rbrd $GOPATH ~/sources/ $ZGEN_DIR ~/.vim/bundle/
}

alias x=':sed-replace:interactive'
:sed-replace:interactive() {
    sed-replace "${@}" '!'

    printf "\n"
    printf "%.0s=" {1..10} "\n"
    printf "Do you want to replace? [y/N] "

    read -r agree

    if grep -qP "[nN]|^$" <<< "$agree"; then
        return
    fi

    sed-replace "${@}"
}

alias np=':carcosa-new-password'
:carcosa-new-password() {
    cd ~/.secrets && \
        carcosa -Sn && \
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

alias ag='ag -f --hidden --silent'
alias /='ag'
alias f='find-alias'
function find-alias() {
    find -iname "*$1*"
}

alias ipa='ip a'

alias vf='vim $(fzf)'
alias vw='vim-which'
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

alias al='alias | grep -P --'

alias ma='mplayer -novideo'
alias yt='youtube-viewer -n'

alias gi='go install'
alias gb='go build'
alias gg='go get -u'

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
            ./run_tests* $run_tests_args
    fi
}

alias a=':ash:inbox-or-review'
function :ash:inbox-or-review() {
    if [ $# -gt 0 ]; then
        ash "${@}"
    else
        ash inbox reviewer
    fi
}

alias an=':ash:review-next'
function :ash:review-next() {
    local review=$(ash inbox reviewer | head -n1 | awk '{ print $1 }')

    ash "$review" "${@}"
}

alias ap='an approve'

alias aa=':ash:open-my-review'
function :ash:open-my-review() {
    local review=$(ash inbox author | head -n1 | awk '{ print $1 }')

    ash "$review"
}


alias am=':ash:merge-my-review'
function :ash:merge-my-review() {
    local review=$(ash inbox author | head -n1 | awk '{ print $1 }')

    ash "$review" merge
}

alias zr='. ~/.zshrc'
alias za='vim -o ~/.zsh/aliases/**/*.zsh && source ~/.zshrc'

alias rf='rm -rf'

zstyle ':completion:*:approximate:::' max-errors 3 not-numeric

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
alias -s  L='uber-ssh:alias -s smart-ssh-tmux -P 192.168.   -R .L'
alias -s  P='uber-ssh:alias -s smart-ssh-tmux -P 172.16.    -R .P'
alias -s  e='uber-ssh:alias -s smart-ssh-tmux -P ngs.ru.    -R .e'
alias -s  p='uber-ssh:alias -s smart-ssh-tmux -A .in.ngs.ru -R .p'
alias -s  x='uber-ssh:alias -s smart-ssh-tmux -R .x'
alias -s  s='uber-ssh:alias -s smart-ssh-tmux'
alias -s ru='uber-ssh:alias -s smart-ssh-tmux'
alias -s rn='uber-ssh:alias -s smart-ssh-tmux'

alias ssh='ssh-urxvt'
alias s='ssh'

smart-ssh-tmux() {
    local format
    if [ "$TMUX" ]; then
        if [ "$(background)" = "dark" ]; then
            format="#[underscore bold bg=colour17 fg=colour226]"
        else
            format="#[underscore bold bg=colour229 fg=colour196]"
        fi
        tmux set status-right "$format φ $SSH_ADDRESS #[default bg=default] "
        tmux set status on
    fi

    smart-ssh "${@}"

    if [ "$TMUX" ]; then
        tmux set status off
    fi
}

function search-domain() {
    local domain=$1
    local resolver_host=$2
    local resolver_port=${3:-53}

    dig @$resolver_host -p$resolver_port axfr s \
        | awk '{print $1}' \
        | grep -P "$domain"
}

function axfr() {
    search-domain "$1" dn.s 53000
}


alias dbfs='ssh-multi -A -- $(search-domain-default "^db..farm") -'
alias yrds='ssh-multi -A -- $(search-domain-default "^ya.*yard.s") -'

alias frts='ssh-multi -A -- $(search-domain-default "^fo.*fortres.s") -'
alias phps='ssh-multi -A -- $(search-domain-default "^phpnode") -'
alias fros='ssh-multi -A -- $(search-domain-default "^frontend") -'
alias mngs='ssh-multi -A -- $(search-domain-default "^mongodb\d+\.") -'
alias tsks='ssh-multi -A -- $(search-domain-default "^task\d+\.") -'
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
    ck ~/sources/"$1" && git init
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

#compdef dotfiles-bootstrap-aur=yaourt

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
            @)
                command man "$1" \
                    | grep -xP '(\S+( |$))+' \
                    | grep -vPi 'name|description|synopsis|author'
                return
                ;;
            # search for section
            @*)
                command vim -u ~/.vimrc-economy \
                    +"set noignorecase" \
                    +"Man $1" \
                    +only \
                    +"/^\(\\S\+.*\|\)\\zs${2:1:u}\\w*\\ze"
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
bindkey -v '^O' toggle-quotes

bindkey -v '^ ' autosuggest-execute

bindkey '^W' smart-backward-kill-word
bindkey '^S' smart-forward-kill-word

bindkey '^P' fuzzy-search-and-edit

bindkey -v '^_' favorite-directories:cd

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
    local dir=$(dirs -p | tail -n+2 | fzf-tmux)
    if [ "$dir" ]; then
        eval cd "$dir"
    fi

    prompt_lambda17_precmd

    context-aliases:on-precmd

    zle reset-prompt
}

function git-clone-to-sources() {
    local who=$1
    local reponame="$2" ; shift
    local clone_path="${2:-$reponame}"

    git clone $who/$reponame ~/sources/$clone_path
    cd ~/sources/$clone_path
}

alias m='git-clone-to-sources github.com:seletskiy'
alias k='git-clone-to-sources github.com:kovetskiy'
alias r='git-clone-to-sources github.com:reconquest'
alias d='git-clone-to-sources git.rn:devops'
alias n='git-clone-to-sources git.rn:ngs'

alias recon='git-clone-reconquest'
function git-clone-reconquest() {
}

function git-clone-to-sources-and-cd() {
    local reponame="$1"
    local dirname="${2:-${reponame#*/}}"

    git clone gh:reconquest/$reponame ~/sources/$dirname
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

alias cr='create-new-project'
function create-new-project() {
    local where=$1
    local project=$2

    local namespace=""
    if [ "${project##*/}" != "$project" ]; then
        local namespace=${project%%/*}/
        local project=${project##*/}
    fi

    local server="github.com"
    local org="seletskiy"
    case "$where" in
        d)
            org="devops"
            server="git.rn"
            ;;
        r)
            org="reconquest"
            server="github.com"
            ;;
    esac

    case "$namespace" in
        go/)
            mkdir -p $GOPATH/src/$server/$org/$project
            cd $GOPATH/src/$server/$org/$project
            git init
            ;;
        *)
            cks $project
            ;;
    esac

    case "$where" in
        d)
            stacket repositories create devops $project
            ;;
        r)
            hub create reconquest/$project
            ;;
        m)
            hub create seletskiy/$project
            ;;
    esac
}

autoload is_inside_git_repo
autoload is_git_repo_dirty
autoload is_rebase_in_progress

alias gc='git clone'
