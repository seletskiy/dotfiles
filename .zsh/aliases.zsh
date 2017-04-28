:aliases:load() {
    unalias -m '*'

    alias help=guess

    alias xdis='printf "Disconnecting from %s" $DISPLAY && export DISPLAY='

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

    alias bl='batrak -L'
    alias bd='batrak -M 21 -n'
    alias bp='batrak -Lf 16058'

    alias fin='get-stock ABBV MSFT TSLA TWTR'

    alias duty:dev='cake --id 41882909 -L'
    alias duty:production='cake --id 39095231 -L'

    alias duty='figlet -f mini devops && duty:dev &&
        figlet -f mini production && duty:production'

    alias //='true'

    alias lgs=':git:show-sources-status'

    alias '$'=':sed-replace:interactive'

    alias x='exec crypt'

    alias cnp=':carcosa:new-password'
    alias cap=':carcosa:add-password'

    alias apm='adb-push-music'

    alias -- ::='systemctl --user'
    alias -- :R=':: daemon-reload'
    alias -- :r=':R && systemctl-command-and-status --user restart'
    alias -- :s=':: status'
    alias -- :t=':: stop'
    alias -- :e=':: enable'
    alias -- :E=':: reenable'
    alias -- :d=':: disable'
    alias -- :l=':: list-unit-files'
    alias -- :p=':: list-dependencies'

    alias -- +x='chmod-alias'

    alias jf='sudo journalctl -ef'
    alias /=':ag'
    alias f='() { find -iname "*$1*" "${@:2}" }'
    alias fd=':find-and-cd'

    alias ipa='ip a'

    alias vf='vim $(fzf)'
    alias vw='() { vim $(which $1) }'

    alias dt='cd $DOTFILES && git status -s'
    alias de='cd $DOTFILES/.deadfiles && git status -s'
    alias kb=':knowledge-base ~/sources/kb'
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

    alias asp='ASPROOT=~/sources/asp asp'

    alias psx=':ps-grep'

    alias al='alias | grep -P --'

    alias ma='mplayer -novideo'
    alias yt='youtube-viewer -n'

    alias gi='go install'
    alias gb='go-fast-build'
    alias gg='go get'

    alias 1='watch -n1'
    alias wt=':watcher:guess'
    alias wto=':watcher:guess -O'

    alias a=':ash:inbox-or-review'
    alias an=':ash:review-next'
    alias ap=':ash:approve'
    alias aa=':ash:open-my-review'
    alias am=':ash:merge-my-review'
    alias az=':ash:fzf'

    alias zr='source ~/.zshrc'
    alias za='vim ~/.zsh/aliases.zsh && source ~/.zsh/aliases.zsh \
        && :aliases:load'

    alias zsw=':zabbix:switch-on-call'
    alias zp='zabbixctl -Tpxxxxd'
    alias zz='zabbixctl -Tpxxxxxd'
    alias zk='zz -k'
    alias zl='zabbixctl -L'
    alias zls=':zabbix:open-graph --stacked'
    alias zln=':zabbix:open-graph --normal'
    alias zl!='zls'

    alias rto='rtorrent "$(ls --color=never -t ~/downloads/*.torrent \
        | head -n1)"'

    alias t='t --task-dir ~/tasks --list tasks'
    alias tf='t -f'

    alias ssh='uber-ssh:alias -s smart-ssh-tmux'

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

    alias -s local='uber-ssh:alias -s smart-ssh-tmux'

    alias ck='() { mkdir -p $1 && cd $1 }'

    alias cks='() { ck ~/sources/"$1" && git init }'

    alias di!="cd $DOTFILES && git-smart-pull && ./bootstrap"
    alias du!="di! $DOTFILES_PROFILE"
    alias di="cd $DOTFILES && ./dotfiles install"
    alias pkg='dotfiles-bootstrap'

    alias aur='dotfiles-bootstrap-aur -S'

    alias godoc='godoc-less'

    alias man='man-search'

    alias m=':sources:clone github.com:seletskiy'
    alias k=':sources:clone github.com:kovetskiy'
    alias r=':sources:clone github.com:reconquest'
    alias d=':sources:clone git+ssh://git.rn/devops'
    alias c=':sources:clone git+ssh://git.rn/core'
    alias n=':sources:clone git+ssh://git.rn/ngs'

    alias gh=':sources:clone github.com:'

    alias mgp=':sources:move-to-gopath'

    alias crd='cr d'
    alias crr='cr r'
    alias crm='cr m'

    alias crdg='create-new-project:go d'
    alias crrg='create-new-project:go r'
    alias crmg='create-new-project:go m'

    alias cr='create-new-project'

    alias gc='git clone'

    alias ns='nodectl:filter'
    alias nsp='nodectl:filter -pp'

    alias xc=':orgalorg:command'

    alias home=':ssh:find-and-connect-vpn-machine'

    alias electrum='command electrum -w btc.wallet'
    alias btc='electrum getbalance | jq -r .confirmed'
    alias btcx='() {
        electrum payto -f "${3:-0.00001}" "$1" "$2" \\
            | electrum signtransaction - \\
            | electrum broadcast -
    }'

    alias tl='stacket repositories list'
    alias tc='stacket repositories create'

    alias pq='printf "%q\n"'

    alias -- '-'=':file:telecopy'

    alias mqs=':orgalorg:mysql "cluster:db role:mysql"'

    alias mh='mcabber-history --ignore-channels=zabbix -S'
    alias mhp='mh postdevops/'

    alias stl='stalk -n 127.1 --'

    alias ua="find -maxdepth 1 -mindepth 1 -type d \
        | xargs -n1 sh -c 'echo \$0; cd \$0; git pull --rebase'"

    alias tg='telegram-cli'

    alias ntl='netctl list'
    alias ntw='netctl switch-to'

    hash-aliases:install

    context-aliases:init

    context-aliases:match is_inside_git_repo
        alias d='git diff'
        alias w='git diff --cached'
        alias a='git-smart-add'
        alias s='git status -s'
        alias o='git log --oneline --graph --decorate --all'
        alias c='git-smart-commit --amend'
        alias p='git-smart-push seletskiy'
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

    context-aliases:match "is_inside_git_repo && git remote show -n origin \
            | grep -q git.rn"
        alias pr='bitbucket:pull-request'
        alias lk='bitbucket:browse'

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

    context-aliases:match "test -e PKGBUILD && find -maxdepth 1 -name '*.tar.xz' | grep -q ."
        alias pu=":repo:upload:repos \$(ls -1t --color=never *.tar.xz \
            | head -n1)"

    context-aliases:match "find -maxdepth 1 -name '*.deb' | grep -q ."
        alias pu=":repo:upload:old \$(ls -1t --color=never *.deb | head -n1)"

    context-aliases:on-precmd
}

# functions
{
    :aliases:eval() {
        local command=$1
        shift

        eval "_alias_eval() { eval \$command; }"

        _alias_eval $@

        unset _alias_eval
    }

    :git:show-sources-status() {
        lsgs -Rbrd $GOPATH/src ~/sources/ $ZGEN_DIR ~/.vim/bundle/
    }

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

    systemctl-command-and-status() {
        systemctl $1 $2 "$3"
        systemctl $1 status "$3"
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
        local extensions=()
        local options=()
        local directory=false

        while [ "${1:---}" != "--" ]; do
            if grep -qPx '\d+' <<< "$1"; then
                timeout="$1"
                shift
                continue
            fi

            if grep -qPx '\w+' <<< "$1"; then
                extensions+=("$1")
                shift
                continue
            fi

            if grep -qP '^[./]$' <<< "$1"; then
                directory=true
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
            command=("go" "test")
        fi

        if find . ./tests -maxdepth 1 -name 'run_tests*' | grep -q "."; then
            command=(./*/run_tests*)
        fi &>/dev/null

        if [ -e Makefile ]; then
            command=("make" "test")
        fi

        if [ -z "${options[*]}" -a "${*:-}" ]; then
            command=("${@}")
        fi

        if [ "${options[*]}" -a "${*:-}" ]; then
            options+=("${@}")
        fi

        if [ -z "${extensions[*]}" ]; then
            extensions=("go" "sh" "py")
        fi

        command+=("${options[@]}")

        regexp="\.(${(j:|:)extensions[@]})$"

        if $directory; then
            extensions=("current directory")
            regexp="."
        fi

        printf "## watching %s files -> %s%s\n" \
            "${(j:, :)extensions[*]}" "${command[*]}" \
            "${timeout:+ (with ${timeout}s timeout)}"

        watcher -e close_write \
            ${timeout:+-w$timeout} "$regexp" -- "${command[@]}"
    }

    :ash:inbox-or-review() {
        if [ $# -gt 0 ]; then
            ash "${@}"
        else
            ash inbox reviewer
        fi
    }

    :ash:review-next() {
        local offset="${1:-1}"
        local review=$(ash inbox reviewer | sed -n "${offset}p" | awk '{ print $1 }')

        ash "$review"
    }

    :ash:open-my-review() {
        local offset="${1:-1}"
        local review=$(ash inbox author | sed -n "${offset}p" | awk '{ print $1 }')

        ash "$review"
    }

    :ash:merge-my-review() {
        local offset="${1:-1}"
        local review=$(ash inbox author | sed -n "${offset}p" | awk '{ print $1 }')

        ash "$review" merge
    }

    :ash:approve() {
        local offset="${1:-1}"
        local review=$(ash inbox reviewer | sed -n "${offset}p" | awk '{ print $1 }')

        ash "$review" approve
    }

    :ash:fzf() {
        local review="$(
            ash inbox \
                | awk '$6 = ":"' \
                | awk -F: '{ print $1 }' \
                | column -xt \
                | fzf \
                | awk '{ print $1 }'
            )"

        if [ -z "$review" ]; then
            return 1
        fi

        ash "$review" "${@}"
    }

    :zabbix:switch-on-call() {
        local next="${1:-$USER}"
        local current=$(
            zabbixctl -G NGS_ADM_WC_MAIN_SEND 2>/dev/null \
                | awk '{print $3}'
        )

        printf "Switching pager duty: %s -> %s\n" "$current" "$next"

        {
            for group in {NGS_ADM_WC_MAIN_SEND,HTTP_NGS_SEND,HTTP_HSDRN_SEND}; do
                zabbixctl -f -G "$group" -a "$next"
                zabbixctl -f -G "$group" -r "$current"
            done

            zabbixctl -f -G NGS_ADM_WC_BACKUP_SEND -a "$current"
            zabbixctl -f -G NGS_ADM_WC_BACKUP_SEND -r "$next"
        } >/dev/null 2>/dev/null

        printf "---\n"
        for group in {NGS_ADM_WC_MAIN_SEND,HTTP_NGS_SEND,HTTP_HSDRN_SEND,NGS_ADM_WC_BACKUP_SEND}; do
            zabbixctl -f -G "$group" 2>/dev/null
        done
    }

    :zabbix:open-graph() {
        zabbixctl -L "${@}" | xargs xdg-open 2>/dev/null
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

    search-domain() {
        local domain=$1
        local resolver_host=$2
        local resolver_port=${3:-53}

        local axfr=$(dig @$resolver_host -p$resolver_port axfr s)

        local records_a=$(awk '$4 == "A" { print $1 }' <<< "$axfr")
        local records_cname=$(awk '$4 == "CNAME" { print $5 }' <<< "$axfr")
        local records_srv=$(awk '$4 == "SRV" { print $1 }' <<< "$axfr" | uniq)

        {
            printf '%s\n' "$records_a"

            # do not show SRV CNAME records
            diff --changed-group-format='%>' --unchanged-group-format='' \
                <(<<< "$records_srv") <(<<< "$records_cname")
        } \
            | grep -v '^\*' \
            | sed -r 's/\.$//' \
            | sort \
            | uniq

    }

    axfr() {
        search-domain "$1" dn.s 53000
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

    smart-insert-last-word-wrapper() {
        _altdot_reset=1
        smart-insert-last-word
    }

    smart-insert-prev-word() {
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

    :sources:clone-and-cd() {
        local reponame="$1"
        local dirname="${2:-${reponame#*/}}"

        git clone gh:reconquest/$reponame ~/sources/$dirname
        cd ~/sources/$dirname
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

    create-new-project() {
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
            g)
                hub create $namespace$project
                ;;
            r)
                hub create reconquest/$project
                ;;
            m)
                hub create seletskiy/$project
                ;;
        esac
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

    bitbucket:browse() {
        local file="$1"
        local line="${2:+#$2}"

        local type=commits
        if [ "$file" ]; then
            type=browse
        fi

        IFS='/' read host project repo <<< $(
            git remote show -n origin \
                | grep -P 'Push +URL' \
                | grep -Po ':/(/[^/]+){3}' \
                | grep -Po '[^@/]+(/[^/]+){2}$'
        )

        printf "http://%s/projects/%s/repos/%s/%s/%s%s\n" \
            "$host" "$project" "$repo" \
            "$type" \
            "$(git rev-parse --short HEAD)" \
            "$line"
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

    :heaver:list-or-attach() {
        if [ $# -lt 2 ]; then
            :heaver:list-containers "$1"
        else
            local containers=($(:heaver:find-container-by-name "$1" "$2"))

            if [ "${#containers[@]}" -eq 0 ]; then
                return 1
            fi

            if [ "${#containers[@]}" -gt 1 ]; then
                printf "%s\n" "${containers[@]}"
                return
            fi

            :heaver:attach \
                "$(:heaver:find-host-by-container-name "$1" "$2")" \
                "${containers[@]}"
        fi
    }

    :heaver:list-containers() {
        local source="$1"
        curl -s --fail $source/v2/h \
            | jq -r '.data[].Containers[] | "\(.host) \(.name)"'
    }

    :heaver:find-host-by-container-name() {
        :heaver:list-containers "$1" | awk "\$2 ~ /$2/" | awk '{ print $1 }'
    }

    :heaver:find-container-by-name() {
        :heaver:list-containers "$1" | awk "\$2 ~ /$2/" | awk '{ print $2 }'
    }

    :heaver:attach() {
        local server="$1"
        local container="$2"

        ssh "$server" -t sudo -i heaver -A "$container"
    }

    :repo:upload:repos() {
        scp "$1" "repo.s:/tmp/$1"
        ssh "repo.s" sudo -i \
            repos -AC -e "${3:-stable}" "${2:-arch-ngs}" "/tmp/$1"
    }

    :repo:upload:old() {
        scp "$1" "repo.in.ngs.ru:/tmp/$1"
        command ssh "repo.in.ngs.ru" -t sudo -i sh -s <<COMMANDS
            cd /data/repositories/ngs-packages/ && \
                mv -v /tmp/$1 ${2:-lucid}/ && \
                ./rescan_${2:-lucid}.sh
COMMANDS
    }

    pdns:cname:new() {
        local name="$1"
        local address="$2"
        local domain=""

        IFS="." read -r domain suffix <<< "$name"

        local zone="${${suffix##*.}:-s}"
        local domain_id="$(pdns domains list -f id -n "$zone")"

        pdns records add -t CNAME -d "$domain_id" \
            -n "${address:-$domain.cname.$zone}" \
            -c "$name"
        pdns soa update -n "$zone"
    }

    pdns:a:new() {
        local name="$1"
        local address="$2"
        local domain=""

        IFS="." read -r domain suffix <<< "$name"

        local zone="${${suffix##*.}:-s}"
        local domain_id="$(pdns domains list -f id -n "$zone")"

        pdns records add -t A -d "$domain_id" -n "$name" -c "$address"
    }

    pdns:srv:new() {
        local name="$1"
        local hostname="$2"
        local port="${3:-80}"
        local domain=""

        IFS="." read -r domain suffix <<< "$name"

        local zone="${${suffix##*.}:-s}"
        local domain_id="$(pdns domains list -f id -n "$zone")"

        pdns records add -t SRV -d "$domain_id" -l 60 \
            -n "$domain.${suffix:-_tcp.s}" -c "0 $port $hostname"
        pdns soa update -n s
    }

    pdns:container:new() {
        local domain=$1
        local ip=$2

        pdns:a:new "$domain" "$ip"
        pdns:cname:new "$domain"
    }

    create-new-project:go() {
        create-new-project "$1" "go/$2"
    }

    :vim-merge() {
        vim -o $(git status -s | grep "^UU " | awk '{print $2}')
    }

    amf:new() {
        cd ~/sources/

        stacket repositories create specs "$1"
        git clone "git+ssh://git.rn/specs/$1"

        cd "$1"

        bithookctl -p pre -A sould primary

        touch amfspec

        git add .
        git commit -m "initial commit"
        git push origin master
    }

    duty:production:update-slack-channel-topic() {
        :heaver:list-or-attach "$HEAVERD_DEVELOPMENT" slack-devops \
            <<< "systemctl restart caked-production &&
                while ! update-duty auto production; do sleep 0.1; done"
    }

    duty:dev:set-slack-channel-topic() {
        :heaver:list-or-attach "$HEAVERD_DEVELOPMENT" slack-devops \
            <<< "update-duty $1 dev"
    }

    nodectl:filter() {
        local include=()
        local exclude=()
        local filter=()
        local args=()

        while [ -n "${*:-}" ]; do
            case "$1" in
                -*)
                    args+=("$1")
                    ;;
                ^*)
                    exclude+=("$1")
                    ;;

                *:*)
                    filter+=("$1")
                    ;;

                *)
                    include+=("$1")
                    ;;
            esac

            shift
        done

        nodectl -S ${args[@]} ${filter[@]} | {
            if [[ "${include[@]:-}" ]]; then
                grep -f <(printf "%s\n" "${include[@]}")
            else
                cat
            fi
        } | {
            if [[ "${exclude[@]:-}" ]]; then
                grep -vf <(printf "%s\n" "${exclude[@]}")
            else
                cat
            fi
        }
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

    orgalorg:shell:with-password() {
        orgalorg -p -o <(nodectl:filter -pp "${@}") -i /dev/stdin -C bash -s
    }

    :orgalorg:mysql() {
        local nodes=(${(s: :)1})
        shift

        local query=$*

        nodectl:filter -pp ${nodes[*]} \
            | orgalorg -spxlC \
                "ls /var/run/mysqld/*.sock | \
                    xargs -n1 -I{} mysql --socket={} -Ne '$query'"
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

    bitbucket:pull-request() {
        stacket-pull-request-create "${@}" && reviewers-add > /dev/null | {
            tee /proc/self/fd/3 \
                | grep devops | {
                    echo '/roster search reviews@'
                    echo -n '/say @here: '
                    cat
                } > ~/.mcabber/fifo/postdevops
        } 3>&1
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

    :ssh:find-and-connect-vpn-machine() {
        local ip=$(
            orgalorg -twc 500 -o192.168.34.{2..15} -C echo 2>/dev/null \
                | awk '{print $1}' \
                | grep -vFf <(ip a | grep -Po 'inet \K[\d.]+')
        )

        if [[ -z "$ip" ]]; then
            echo "can't find connected vpn machine" >&2
            return 1
        fi

        uber-ssh:alias -s smart-ssh-tmux "$ip"
    }

    :ag() {
        ag -f --hidden --silent -- "${(j:.*?:)@}"
    }

    :knowledge-base:toc:overwrite() {
        local readme="$1"

        touch "$readme"

        sed -r '/^\s*\*/,$d' -i "$readme"

        :knowledge-base:toc:generate "${readme:h}" >> "$readme"
    }

    :knowledge-base:toc:generate() {
        local dir="$1"

        cd "$dir"

        tree --noreport -ifP '*.md' \
            | sed -r '1d;s|^\./||' \
            | grep -v '^README' \
            | sed -r 's|\S+|&\n(&)|' \
            | sed -r '/^[^(]/{s|(.*)[0-9]{2}-|\1|;s|[^/]+/|\t|g}' \
            | sed -r '/^[^(]/{s|-| |g;s|\.md||;s|\S.*|[&]|}' \
            | sed -r '/\[/{N;s|\n||}' \
            | sed -r 's|\S|* &|'
    }

    :knowledge-base:create() {
        local base="$1"
        shift

        local glob="${(j:/:)${${@:1:-1}[@]/#/*-}}"
        local name="${@[-1]}"

        cd "$base"

        if ! eval "cd $glob" &>/dev/null; then
            printf "%s\n" "specified directory tree does not exist"
            return 1
        fi

        local index=$(
            find -type f \
                | sed -r 's|^\./||' \
                | grep -oP '^\d{2}' \
                | sort -rn \
                | head -n1
        )

        local next=$(printf "%02d" "$(( index + 1 ))")

        vim "$next-$name.md"

        :knowledge-base:toc:overwrite "$base/README.md"
    }

    :knowledge-base() {
        if [[ ! "${*}" ]]; then
            return
        fi

        :knowledge-base:create "${@}"
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

    :file:telecopy() {
        local source="$1"

        local pipe="/tmp/zsh-telecopy.pipe"

        if [[ -p "$pipe" ]]; then
            {
                local filename="$(head -n1)"

                printf 'Receiving %s...\n' "$filename"

                cat >! "$(basename "$filename")"
            } < $pipe

            rm "$pipe"
        else
            if [[ ! -f "$source" ]]; then
                printf 'No such file: %s\n' "$source"

                return 1
            fi >&2

            mkfifo "$pipe"

            {
                realpath "$source"

                cat "$source"
            } > $pipe
        fi
    }

    _autocd() {
        if [[ "${BUFFER:0:1}" == " " ]]; then
            CURRENT=$((CURRENT + 1))
            _cd
        else
            _command_names
        fi
    }
}
