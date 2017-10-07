:aliases:load() {
    unalias -m '*'

    alias help=guess

    alias sudo='sudo '

    alias v='vim'
    alias vi='vim'

    alias ls='ls --color=auto'
    alias l='ls --group-directories-first --time-style=long-iso -tAlh'
    alias ll='ls -al'
    alias li='\k'
    alias lt='ls -alt'

    alias rf='rm -rf'

    alias cu='curl -LO'

    alias g='git init'
    alias z='zfs list'

    alias skr='ssh-keygen -R'

    alias i='image-upload'

    alias //='true'

    alias '$'=':sed-replace:interactive'

    alias u='exec usb-shell'

    alias cnp=':carcosa:new-password'
    alias cap=':carcosa:add-password'

    alias apm='adb-push-music'

    alias -- :!='sudo systemctl'
    alias -- :r!=':! daemon-reload && () {
        :! restart "$1"
        :! status "$1"
    }'
    alias -- :s!=':! status'
    alias -- :t!=':! stop'
    alias -- :e!=':! enable'
    alias -- :ee!=':! reenable'
    alias -- :d!=':! disable'
    alias -- :l!=':! list-unit-files'
    alias -- :p!=':! list-dependencies'
    alias -- :j!='journalctl --user'
    alias -- :jf!=':j -f'
    alias -- :y!='() {
        systemctl --user status "$(
            systemd-run --user "$@" 2>&1 | grep -Po "Running as unit: \\K.*"
        )"
    }'

    alias -- ::='systemctl --user'
    alias -- :r=':: daemon-reload && () {
        :: restart "$1"
        :: status "$1"
    }'
    alias -- :s=':: status'
    alias -- :t=':: stop'
    alias -- :e=':: enable'
    alias -- :ee=':: reenable'
    alias -- :d=':: disable'
    alias -- :l=':: list-unit-files'
    alias -- :p=':: list-dependencies'
    alias -- :j='journalctl --user'
    alias -- :jf=':j -f'
    alias -- :y='() {
        systemctl --user status "$(
            systemd-run --user "$@" 2>&1 | grep -Po "Running as unit: \\K.*"
        )"
    }'

    alias -- +x='chmod-alias'

    alias jf='sudo journalctl -ef'
    alias /=':ag'
    alias /g='AG_ARGS=--go :ag'
    alias f='() { find -iname "*$1*" "${@:2}" }'
    alias fd=':find-and-cd'

    alias ipa='ip a'

    alias vf='vim $(fzf)'
    alias vw='() { vim $(which $1) }'

    alias dt='cd $DOTFILES && git status -s'
    alias de='cd $DOTFILES/.deadfiles && git status -s'
    alias se='cd ~/.secrets && carcosa -Lc | sort'

    alias pp='sudo pacman -S'
    alias pp!='yes | sudo pacman --force --noconfirm -S'
    alias ppy='sudo pacman -Sy'
    alias ppyu='sudo pacman -Syu'
    alias ppr='sudo pacman -R'
    alias pqo='pacman -Qo'
    alias pql='pacman -Ql'
    alias pqs='pacman -Qs'
    alias pqi='pacman -Qi'
    alias ppu='sudo pacman -U'
    alias pps='pacman -Ss'
    alias po='pkgfile'
    alias ppo='() { pp "$(po "$1")" }'
    alias ppyu='sudo pacman -Syu'
    alias ppyuz='ppyu --ignore linux,zfs-linux-git,zfs-utils-linux-git,spl-linux-git,spl-utils-linux-git'

    alias zgu='zgen update && zr'

    alias psx=':ps-grep'

    alias al='alias | grep -P --'

    alias ma='mplayer -novideo'

    alias gi='go install'
    alias gb='go-fast-build'
    alias gg='go get'

    alias 1='watch -n1'
    alias wt=':watcher:guess'
    alias wto=':watcher:guess -O'

    alias zr='source ~/.zshrc'
    alias za='vim ~/.zsh/aliases.zsh && source ~/.zsh/aliases.zsh \
        && :aliases:load'

    alias rto='rtorrent "$(ls --color=never -t ~/downloads/*.torrent \
        | head -n1)"'

    alias ssh='uber-ssh:alias -s smart-ssh-tmux'

    alias -s  L='uber-ssh:alias -s smart-ssh-tmux -P 192.168.   -R .L'
    alias -s  s='uber-ssh:alias -s smart-ssh-tmux'
    alias -s ru='uber-ssh:alias -s smart-ssh-tmux'

    alias ck='() { mkdir -p $1 && cd $1 }'

    alias di!="cd $DOTFILES && git-smart-pull && ./bootstrap"
    alias du!="di! $DOTFILES_PROFILE"
    alias di="cd $DOTFILES && ./dotfiles install"

    alias aur='yaourt --noconfirm -S'

    alias godoc='godoc-less'

    alias man='man-search'

    alias m=':sources:clone github.com:seletskiy'
    alias k=':sources:clone github.com:kovetskiy'
    alias r=':sources:clone github.com:reconquest'

    alias gh=':sources:clone github.com:'
    alias gb=':sources:clone bitbucket.org:'

    alias mgp=':sources:move-to-gopath'

    alias gc='git clone'

    alias xc=':orgalorg:command'

    alias electrum='command electrum -w btc.wallet'
    alias btc='electrum getbalance | jq -r .confirmed'
    alias btcx='() {
        electrum daemon start
        electrum daemon load_wallet
        electrum payto -f "${3:-0.0017}" "$1" "$2" \\
            | electrum signtransaction - \\
            | electrum broadcast -
        electrum daemon stop
    }'

    alias pq='printf "%q\n"'

    alias -- '-'=':pipe'
    alias -- '-:'=':pipe:tar:send'
    alias -- ':-'=':pipe:tar:receive'

    alias mh='mcabber-history -S'

    alias stl='stalk -n 127.1 --'

    alias prefix='() {
        while read -n line; do printf "%s%s\n" "$1" "$line"; done
    }'

    alias ua='find -maxdepth 1 -mindepth 1 -type d |
        cut -b3- |
        while read -n dir; do
            ( cd $dir; [ -d .git ] && git pull --rebase |& prefix "{$dir} "; )
        done'

    alias ntl='netctl list'
    alias ntw='netctl switch-to'

    alias 8='ping 8.8.8.8'

    alias -g -- '#cc'='| xclip -i'

    alias ku=':kubectl'
    alias kaf='ku apply -f'
    alias kdf='ku delete -f'

    alias kdp='ku delete pods'
    alias kbb='ku run -i --tty --image radial/busyboxplus busybox-$RANDOM --restart=Never --rm'

    alias kg='ku get'
    alias kgp='kg pods'
    alias kgp!='kgp --all-namespaces'
    alias kgn='ku get nodes'

    alias kp='() { kgp "${@:2}" -o name | cut -f2- -d/ | grep -F ${1}; }'
    alias kl='ku logs'
    alias klf='kl -f --tail=0'
    alias ke='ku exec -it'
    alias kc='ku config use-context'
    alias kff='ku port-forward'
    alias ks='ku describe'

    alias mks='minikube start --cpus 1 --memory 1024'
    alias mks!='minikube stop'
    alias mke='eval $(minikube docker-env)'

    alias pk='pkill -f'

    alias x=':context:command magalix'
    alias mk=':context:command minikube'

    alias forever='() { while :; do eval "$@"; done; }'

    hash-aliases:install

    context-aliases:init

    context-aliases:match is_inside_git_repo
        alias d='git diff'
        alias w='git diff --cached'
        alias a='git-smart-add'
        alias s='git status -s'
        alias o="git log --graph --all \
            --format='format:%C(yellow)%h %Cblue%>(12)%ad%Cred%d %Creset%s' \
            --date=relative"
        alias c='git-smart-commit --amend'
        alias p='git-smart-push seletskiy'
        alias t='() { c "$@" && p ; }'
        alias t!='() { c "$@" && p! ; }'
        alias k='git-smart-checkout'
        alias j='k master'
        alias j!='j && rst!'
        alias ju='j && u'
        alias r='git-smart-remote'
        alias e=':git:rebase-interactive'
        alias b='git branch'
        alias bm='git branch -m'
        alias h='git reset HEAD'
        alias i='git add -p'
        alias ii=':git:commit:interactively'
        alias M='git mv'
        alias R='git rm'
        alias y='git show'
        alias ys='y --stat'
        alias q='git submodule update --init --recursive'
        alias n='git checkout -b'
        alias r='u && p'
        alias G='cd-pkgbuild'
        alias S='git stash -u && git stash drop'
        alias R!='git rm -f'
        alias a!='git-smart-commit -a --amend'
        alias c!='git-smart-commit --amend'
        alias p!='git-smart-push seletskiy +`git symbolic-ref --short -q HEAD`'
        alias u='git-smart-pull --rebase'
        alias g='k pkgbuild'
        alias gm='g && m'
        alias gmp='gm && pu'
        alias rs='git-smart-remote show'
        alias ru='git-smart-remote set-url'
        alias kn='git checkout -b'
        alias kj='git checkout -B'
        alias rso='git-smart-remote show origin'
        alias st='git stash'
        alias stp='st show -p'
        alias fk='hub fork'
        alias pr='hub pull-request'
        alias lk='github-browse'
        alias cln!='git clean -ffdx'
        alias cln='cln! -n'
        alias rst!='git reset --hard'

        alias lk='github:browse'
        alias mm='git-merge-with-rebase'
        alias me='git-remote-add-me'

        alias prr='p && pr'

		alias au='git log --format=%aN | sort -u'

        alias gg='() { git grep $1 $(git rev-list --all) -- ${@:2} }'

    context-aliases:match "test -e PKGBUILD"
        alias g='go-makepkg-enhanced'
        alias m='makepkg -f'
        alias mu='m && ppu'

        alias aur='push-to-aur'

        alias mb=':makepkg:branch'

    context-aliases:match "test -e Makefile"
        alias m='make -j8'
        alias mt='make test'

    context-aliases:match "is_inside_git_repo && is_git_repo_dirty"
        alias c='git-smart-commit'

    context-aliases:match "is_inside_git_repo && \
            ! { git log 2>/dev/null | grep -qm1 . }"
        alias c='git add . && git commit -m "initial commit"'

    context-aliases:match "is_inside_git_repo && is_rebase_in_progress"
        alias m='git checkout --ours'
        alias t='git checkout --theirs'
        alias c='git rebase --continue'
        alias b='git rebase --abort'

    context-aliases:match '[ "$(pwd)" = ~/.secrets ]'
        alias u='carcosa -Sn'

    context-aliases:match 'is_inside_git_repo && [ -f .git/MERGE_MSG ]'
        alias m=':vim-merge'

    context-aliases:match '[ "$CONTEXT" = "magalix" ]'
        alias i='influx -host magalix -port 8086 -database k8s'
        alias gh=':sources:clone github.com:MagalixTechnologies'

    context-aliases:match '[ "$CONTEXT" = "minikube" ]'
        alias ku=':kubectl @minikube'
        alias gh=':sources:clone github.com:MagalixTechnologies'

    context-aliases:on-precmd '[ "$(pwd)" = ~/notes ]'
        alias sync='adb push * /sdcard/notes'

    context-aliases:on-precmd
}

# functions
{
    :sed-replace:interactive() {
        if [[ "$#" -lt 2 ]]; then
            echo 'usage: sed-replace <from> <to> [<file>...]'

            return 1
        fi

        if [[ "$#" -lt 3 ]]; then
            :sed-replace:interactive "$1" "$2" **/*

            return
        fi

        sed-replace "${@}" '!'

        printf "\n"
        printf "%.0s=" {1..10}
        printf "\nDo you want to replace? [y/N] "

        read -r agree

        if grep -qP "[nN]|^$" <<< "$agree"; then
            return
        fi

        sed-replace "${@}"
    }

    :carcosa:new-password() {
        pwgen 10 1 \
            | xclip -f \
            | :carcosa:add-password "$1"
    }

    :carcosa:add-password() {
        cd ~/.secrets

        carcosa -Ac "passwords/$1"
    }

    adb-push-music() {
        local dir=$1

        adb push $dir /storage/sdcard1/Music/
        adb shell am broadcast -a android.intent.action.MEDIA_MOUNTED \
            -d file:///storage/sdcard1/
    }

    :find-and-cd() {
        cd "$(
            f "$1" -type d \
                | grep -vw '\.git' \
                | head -n1
        )"
    }

    :watcher:guess() {
        local timeout=""
        local patterns=()
        local message=()
        local options=()
        while [ "${1:---}" != "--" ]; do
            if grep -qPx '\d+' <<< "$1"; then
                timeout="$1"
                shift
                continue
            fi

            if grep -qPx '\w+\.\w+' <<< "$1"; then
                patterns+=("$1")
                message+=("$1")
                shift
                continue
            fi

            if grep -qPx '\w+' <<< "$1"; then
                patterns+=("\.$1$")
                message+=("$1")
                shift
                continue
            fi

            if grep -qP '^[./]$' <<< "$1"; then
                patterns=(".")
                message+=("current directory")
                shift
                continue
            fi

            if grep -qP '^-' <<< "$1"; then
                options+=("$1")
                shift
                break
            fi

            break
        done

        if [ "${1:-}" = "--" ]; then
            shift
        fi

        local command=""

        if find -maxdepth 1 -name '*.go' | grep -q "."; then
            command=("go-fast-build")
        fi

        if find -maxdepth 1 -name '*_test.go' | grep -q "."; then
            command=("go" "test")
        fi

        if find . ./tests -maxdepth 1 -name 'run_tests*' | grep -q "."; then
            command=(./*/run_tests*)
        fi &>/dev/null

        if [[ -e Makefile ]] && grep -qP '^test:' Makefile; then
            command=("make" "test")
        fi

        if [ -z "${options[*]}" -a "${*:-}" ]; then
            command=("${@}")
        fi

        if [ "${options[*]}" -a "${*:-}" ]; then
            options+=("${@}")
        fi

        if [ -z "${patterns[*]}" ]; then
            patterns=("\.go$" "\.sh$" "\.py$")
            message=("go" "sh" "py")
        fi

        command+=("${options[@]}")

        regexp="${(j:|:)patterns[@]}"

        printf "## watching %s files -> %s%s\n" \
            "${(j:, :)message[*]}" "${command[*]}" \
            "${timeout:+ (with ${timeout}s timeout)}"

        watcher -e close_write \
            ${timeout:+-w$timeout} "$regexp" -- "${command[@]}"
    }

    smart-ssh-tmux() {
        (
            smart-ssh-tmux:cleanup() {
                if [ "$TMUX" ]; then
                    tmux set status off
                    tmux rename-window ""
                fi
            }

            trap "smart-ssh-tmux:cleanup && exit 1" INT

            local format
            if [ "$TMUX" ]; then
                if [ "$(background)" = "dark" ]; then
                    format="#[underscore bold bg=colour17 fg=colour226]"
                else
                    format="#[underscore bold bg=colour229 fg=colour196]"
                fi

                local tmux_status="$format φ $SSH_ADDRESS #[default bg=default] "

                tmux set status-left "$tmux_status"
                tmux set status-left-length "${#tmux_status}"
                tmux set status on

                tmux rename-window "ssh [$SSH_ADDRESS]"
            fi

            smart-ssh "${@}"

            smart-ssh-tmux:cleanup
        )
    }

    dotfiles-bootstrap() {
        local url=$1
        if [ -z "$1" ]; then
            url=$(xclip -o)
        fi

        if grep -qP "^https?:" <<< "$url"; then
            local line="-        $url"
            $DOTFILES/bootstrap $DOTFILES_PROFILE <<< "$line"
            if [ $? -eq 0 ]; then
                if ! grep -qFx -- "$line" $DOTFILES/profiles.txt; then
                    echo "$line" >> $DOTFILES/profiles.txt
                fi
                return 1
            fi
        else
            grep "${@}" $DOTFILES/profiles.txt \
                | $DOTFILES/bootstrap $DOTFILES_PROFILE

        fi
    }

    dotfiles-bootstrap-aur() {
        shift
        dotfiles-bootstrap https://aur.archlinux.org/packages/$1
    }

    dotfiles:migrate-to-deadfiles() {
        local subject="$1"
        shift

        if [[ ! "$*" ]]; then
            echo 'files argument required' >&2
            return 1
        fi

        (
            local dotfiles=$DOTFILES
            local deadfiles=$DOTFILES/.deadfiles

            cd $dotfiles
            git stash
            git pull --rebase origin master

            cd $deadfiles
            git stash
            git pull --rebase origin master

            for file in $@; do
                install -DT $dotfiles/$file $deadfiles/$file
                rm -r $dotfiles/$file
            done

            cd $deadfiles
            git add .
            git commit -m "$subject migrated from seletskiy/dotfiles"
            git push origin master
            git stash pop

            cd $dotfiles
            git add .
            git commit -m "$subject migrated to deadcrew/deadfiles"
            git push origin master
            git stash pop
        )
    }


    godoc-less() {
        \godoc -ex "${@}" | less -SX
    }

    man-search() {
        if [[ ! -t 1 ]]; then
            command man "$@"
            return
        fi

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

    prepend_sudo() {
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

    noop() {
        # nothing
    }

    chmod-alias() {
        if [ $# -eq 0 ]; then
            chmod +x $(fc -ln -1 | awk '{print $1}')
        else
            chmod +x "${@}"
        fi
    }

    leap-back() {
        local dir=$(dirs -p | tail -n+2 | fzf-tmux)
        if [ "$dir" ]; then
            eval cd "$dir"
        fi

        for func in "${precmd_functions[@]}"; do
            "$func"
        done

        zle reset-prompt
    }

    :sources:clone() {
        local who=$1
        local reponame="$2" ; shift
        local clone_path="${${2:-${${who##*/}%:}/$reponame}//://}"

        if [ -z "$1" ]; then
            return
        fi

        git clone $who/$reponame ~/sources/$clone_path
        if [[ "$?" != "0" ]]; then
            return 1
        fi

        cd ~/sources/$clone_path

        local site=$(
            git remote show origin -n \
                | awk '/Fetch URL/ { print $3 }' \
                | grep -Po '[^/:]+[^/:]' \
                | head -n1
        )

        if find -name '*.go' | grep -qm 1 . || grep -q 'go-' <<< "$reponame"
        then
            :sources:move-to-gopath "." "$site"
        fi
    }

    :sources:move-to-gopath() {
        local directory=${1:-.}
        local site=${2:-github.com}
        local remote=${3:-origin}

        directory=$(readlink -f .)
        cd $directory

        local repo_path=$(
            git remote show $remote -n \
                | awk '/Fetch URL/{print $3}' \
                | cut -f2 -d:
        )

        local target_path=$GOPATH/src/$site/$repo_path

        mkdir -p $(dirname $target_path)

        mv $directory $target_path

        cd $target_path
    }

    github:browse() {
        local file="$1"
        local line="${2:+#L$2}"

        local type=commit
        if [ "$file" ]; then
            type=blob
        fi

        hub browse -u -- $type/$(git rev-parse --short HEAD)/$file$line \
            2>/dev/null
    }

    git-merge-with-rebase() {
        local branch=$(git rev-parse --abbrev-ref HEAD)
        if git rebase "${@}"; then
            git checkout $1
            git merge --no-ff "$branch" "${@}"
        fi
    }

    _git-merge-with-rebase() {
        service="git-merge" _git "${@}"
    }

    git-remote-add-me() {
        if [ "$1" ]; then
            local repo="gh:seletskiy/$1"; shift
        else
            local repo=$(
                git remote show origin -n \
                    | awk '/Fetch URL/{print $3}'
            )
            repo=$(sed -res'#(.*)/([^/]+)/([^/]+)$#\1/seletskiy/\3#' <<< $repo)
        fi

        git remote add seletskiy "$repo" "${@}"
    }

    :git:rebase-interactive() {
        if grep -Pqx '\d+' <<< "$1"; then
            git rebase -i HEAD~$1 ${@:2}
        else
            git rebase "${@}"
        fi
    }

    push-to-aur() {
        local package_name="${1:-$(basename $(git rev-parse --show-toplevel))}"
        local package_name=${package_name%*-pkgbuild}
        local package_name=${package_name}-git

        git push ssh://aur@aur.archlinux.org/$package_name pkgbuild:master
    }

    :makepkg:branch() {
        local branch="$1"

        sed -r \
            '/source/,/md5sums/ {
                s/(.git)(#.+)?($|"|\))/\1#branch='$branch'\3/
            }' \
            -i PKGBUILD

        makepkg -f
    }


    :vim-merge() {
        vim -o $(git status -s | grep "^UU " | awk '{print $2}')
    }

    orgalorg:upload() {
        local hosts=$1
        local root=$2

        shift 2

        hosts=("${${(s/,/)hosts}[@]//#/-o}")

        orgalorg "${hosts[@]}" -x -y -e -r "$root" -U "$@"
    }

    orgalorg:upload:run() {
        local command=$1
        local hosts=$2
        local root=$3

        shift 3

        hosts=("${${(s/,/)hosts}[@]//#/-o}")

        orgalorg "${hosts[@]}" -x -y -e -r "$root" -n "$command" -S "$@"
    }


    :orgalorg:command() {
        local hosts=()

        while [[ "${1:---}" != "--" ]]; do
            hosts+=("$1")

            shift
        done

        shift

        local flags=("${hosts[@]//#/-o}")

        :orgalorg "${flags[@]}" -pxy -C "$@"
    }

    :orgalorg() {
        orgalorg -u "$SSH_USERNAME" "$@"
    }

    :go:compile-and-run() {
        local pwd="$(pwd)"
        local name="$(basename "$pwd")"
        local binary="$pwd/$name"

        if grep -q "$GOPATH" <<< "$pwd"; then
            if ! go-fast-build; then
                return 1
            fi
        fi

        if stat "$binary" &>/dev/null; then
            "$binary" "$@"
        else
            echo "nothing to launch" >&2
            return 1
        fi
    }

    :ag() {
        ag $AG_ARGS -f --hidden --silent -- "${(j:.*?:)@}"
    }

    :ps-grep() {
        if [[ "${*}" ]]; then
            ps axfu | grep "${@}"
        else
            ps axfu | less
        fi
    }

    :git:commit:interactively() {
        local message
        while git add -p; do
            if git diff --cached --quiet; then
                highlight bold fg red
                printf ':: no changes detected\n'
                return 0
            fi

            highlight bold fg yellow
            printf ':: following changes will be commited\n'
            highlight reset

            git diff --cached

            printf '\n'

            message=$(grep -Po '^([^:]+:) ' <<< "$message")

            local prompt=$(
                printf "%s%s: %s" \
                    "$(highlight bold fg blue)" \
                    "Commit message [empty to amend HEAD]" \
                    "$(highlight reset)"
            )

            vared -p "$prompt"  message

            if [[ "$message" ]]; then
                git commit -m "$message"
            else
                git commit --amend -C HEAD
            fi

            printf '\n'
        done
    }

    :pipe() {
        local pipe="/tmp/zsh.pipe"

        if [[ -t 0 ]]; then
            cat "$pipe"
        else
            if [[ ! -p "$pipe" ]]; then
                mkfifo "$pipe"
            fi
            cat > "$pipe"
            rm "$pipe"
        fi
    }

    :pipe:tar:send() {
        tar c "${1:-.}" | :pipe
    }

    :pipe:tar:receive() {
        :pipe | tar x
    }

    :kubectl:file() {
        local command=$1
        shift

        :kubectl $command "-f${^@}"
    }

    :context:command() {
        CONTEXT=$1 context-aliases:on-precmd

        shift

        eval "${(q)@}"
    }

    _autocd() {
        if [[ "${BUFFER:0:1}" == " " ]]; then
            CURRENT=$((CURRENT + 1))
            _cd
        else
            _command_names
        fi
    }

    :kubectl() {
        local arg
        local context
        local args=()
        local entity

        for arg in "$@"; do
            if [[ "$arg" =~ @.* ]]; then
                context=$(
                    kubectl config get-contexts --no-headers -o name \
                        | grep -F "${arg:1}"
                )
            else
                args+=("$arg")
            fi
        done

        set -- "${args[@]}"

        args=()
        targets=()

        for arg in "$@"; do
            if [[ "$arg" =~ %.* ]]; then
                entity=${arg%/*}

                if [[ "$entity" == "$arg" ]]; then
                    entity=pod
                fi

                args+=($(
                    kubectl --context=$context get "$entity" --no-headers \
                            -o name \
                        | cut -f2- -d/ \
                        | grep -F "${${arg:1}#*/}"
                ))
            else
                args+=("$arg")
            fi
        done

        if [[ ! "$context" ]]; then
            printf ":: no context found matching specifier\n"
            return 1
        fi

        kubectl --context=$context ${(q)args[@]}
    }
}
