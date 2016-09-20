# detect zsh -is
{
    INTERACTIVE=$([ -t 0 ] && echo 1)

    :is-interactive() {
        [ "$INTERACTIVE" ]
    }
}

# globals
{
    ZDOTDIR=~/.zsh

    ZGEN_DIR=$ZDOTDIR/.zgen/

    DOTFILES_PATH=~/sources/dotfiles

    KEYTIMEOUT=1

    AUTOPAIR_INHIBIT_INIT=1

    HEAVERD_PRODUCTION='foci.cname.s:8081'
    HEAVERD_DEVELOPMENT='container.s:8081'
}

# environment
{
    display=$DISPLAY

    eval $(
        eval ${SUDO_USER:+sudo -iu $SUDO_USER} \
            DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS \
            systemctl --user show-environment \
                | sed "s/^/export /"
    )

    export DISPLAY=${display:-$DISPLAY}
}

# prezto
{
    # wow, such integration! https://github.com/tarjoilija/zgen/pull/27
    ln -sfT $ZDOTDIR/.zgen/sorin-ionescu/prezto-master $ZDOTDIR/.zprezto

    zstyle ':prezto:*:*' case-sensitive 'yes'

    zstyle ':prezto:*:*' color 'yes'

    zstyle ':prezto:load' pmodule \
        'environment' \
        'terminal' \
        'editor' \
        'history' \
        'directory' \
        'completion' \
        'history-substring-search'

    zstyle ':prezto:module:editor' key-bindings 'vi'
}

# plugins
{
    {
        if ! :is-interactive; then
            compinit() {
                :
            }

            compdef() {
                :
            }
        fi

        # unless, zsh will crash with core dumped
        if ! type zgen >/dev/null 2>&1; then
            source /usr/share/zsh/scripts/zgen/zgen.zsh
        fi

        zle() {
            if [[ "$1" == "-R" || "$1" == "-U" ]]; then
                unset -f zle

                :plugins:load
                :plugins:post-init

                :hijack:load
                :aliases:load
            fi

            builtin zle "${@}"
        }
    }

    :plugins:post-init() {
        {
            fpath=(${ZGEN_COMPLETIONS[@]} $fpath)
        }

        {
            unsetopt correct
            unsetopt correct_all
            unsetopt global_rcs

            setopt menu_complete
        }

        {
            zstyle ':smart-ssh' ssh 'ssh-urxvt'
        }

        {
            favorite-directories:get() {
                echo src 1 ~/sources
                echo zsh 2 ~/.zsh/.zgen
                echo vim 2 ~/.vim
                echo go 3 ~/.go/src
            }
        }

        if :is-interactive; then
            {
                if [ ! "$_autopair_initialized" ]; then
                    _autopair_initialized=1
                    autopair-init
                fi
            }

            {
                eval "$(sed -r -e 's/\+s//' -e '/bindkey/d' \
                    /usr/share/fzf/key-bindings.zsh)"
            }

            {
                if [ "$BACKGROUND" = "light" ]; then
                    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=250"
                else

                    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=240"
                fi

                ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd
            }

            {
                zstyle ':zle:smart-kill-word' precise always
                zstyle ':zle:smart-kill-word' keep-slash on
            }

            {
                if [ ${+functions[manydots-magic]} -eq 0 ]; then
                    autoload -Uz manydots-magic
                    manydots-magic
                fi
            }
        fi

        compinit
    }

    {
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern hijack)
        ZSH_HIGHLIGHT_PATTERNS=('//*' 'fg=245')
    }

    if ! zgen saved; then
        zgen load seletskiy/zsh-zgen-compinit-tweak
        zgen load sorin-ionescu/prezto
        zgen load mafredri/zsh-async
        zgen load seletskiy/zsh-fuzzy-search-and-edit
        zgen load seletskiy/zsh-prompt-lambda17

        zgen save

        zgen init
    fi

    :plugins:load() {
        zgen load kovetskiy/zsh-smart-ssh
        zgen load seletskiy/zsh-ssh-urxvt
        zgen load seletskiy/zsh-context-aliases
        zgen load seletskiy/zsh-git-smart-commands
        zgen load seletskiy/zsh-hijack
        zgen load seletskiy/zsh-hash-aliases
        zgen load seletskiy/zsh-uber-ssh
        zgen load deadcrew/deadfiles

        if :is-interactive; then
            zgen load seletskiy/zsh-ash-completion
            zgen load seletskiy/zsh-smart-kill-word
            zgen load kovetskiy/zsh-add-params
            zgen load kovetskiy/zsh-quotes
            zgen load seletskiy/zsh-favorite-directories
            zgen load hlissner/zsh-autopair autopair.zsh
            zgen load knu/zsh-manydots-magic
            zgen load brnv/zsh-too-long
            zgen load seletskiy/zsh-syntax-highlighting

            # must be last!
            zgen load seletskiy/zsh-autosuggestions
        fi
    }
}

if :is-interactive; then
    # prompt
    {
        source /usr/share/zsh/functions/Prompts/promptinit

        prompt lambda17

        zstyle 'lambda17:05-sign' text "☫"

    }

    # term
    {
        if [ "$BACKGROUND" ]; then
            eval `dircolors ~/.dircolors.$BACKGROUND`
            if [ "$TMUX" ]; then
                export TERM=screen-256color
            fi
        fi
    }

    # ctrl-q
    {
        stty -ixon
    }
else
    PS1=""
fi

# functions
{
    :git:show-sources-status() {
        lsgs -Rbrd $GOPATH/src ~/sources/ $ZGEN_DIR ~/.vim/bundle/
    }

    :sed-replace:interactive() {
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

    :carcosa-new-password() {
        cd ~/.secrets && \
            carcosa -Sn && \
            pwgen 10 1\
                | tee /dev/stderr \
                | xclip -f \
                | carcosa -Ac "passwords/$1"
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

    :find() {
        find -iname "*$1*" "${@:2}"
    }

    :find-and-cd() {
        cd "$(
            :find "$1" -type d \
                | grep -vw '\.git' \
                | head -n1
        )"
    }

    vim-which() {
        vim "$(which "$1")"
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
        local format
        if [ "$TMUX" ]; then
            if [ "$(background)" = "dark" ]; then
                format="#[underscore bold bg=colour17 fg=colour226]"
            else
                format="#[underscore bold bg=colour229 fg=colour196]"
            fi
            tmux set status-right \
                "$format φ $SSH_ADDRESS #[default bg=default] "
            tmux set status on
            tmux rename-window "ssh [$SSH_ADDRESS]"
        fi

        smart-ssh "${@}"

        if [ "$TMUX" ]; then
            tmux set status off
            tmux rename-window ""
        fi
    }

    search-domain() {
        local domain=$1
        local resolver_host=$2
        local resolver_port=${3:-53}

        dig @$resolver_host -p$resolver_port axfr s \
            | awk '{print $1}' \
            | grep -P "$domain"
    }

    axfr() {
        search-domain "$1" dn.s 53000
    }

    mkdir-and-cd() {
        mkdir -p $1 && cd $1
    }

    ck-source-dir() {
        ck ~/sources/"$1" && git init
    }

    dotfiles-bootstrap() {
        local url=$1
        if [ -z "$1" ]; then
            url=$(xclip -o)
        fi

        if grep -P "^https?:" <<< "$url"; then
            local line="-        $url"
            $DOTFILES_PATH/bootstrap $DOTFILES_PROFILE <<< "$line"
            if [ $? -eq 0 ]; then
                if ! grep -qFx -- "$line" $DOTFILES_PATH/profiles.txt; then
                    echo "$line" >> $DOTFILES_PATH/profiles.txt
                fi
                return 1
            fi
        else
            grep "${@}" $DOTFILES_PATH/profiles.txt \
                | $DOTFILES_PATH/bootstrap $DOTFILES_PROFILE

        fi
    }

    dotfiles-bootstrap-aur() {
        shift
        dotfiles-bootstrap https://aur.archlinux.org/packages/$1
    }

    godoc-less() {
        \godoc -ex "${@}" | less -SX
    }

    man-search() {
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
        local clone_path="${2:-$reponame}"

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
                ck-source-dir $project
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
        ssh "repo.in.ngs.ru" -t sudo -i sh -s <<COMMANDS
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

    orgalorg:shell:with-password() {
        orgalorg -p -o <(nodectl:filter -pp "${@}") -i /dev/stdin -C bash -s
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
                | awk '{print $1}'
        )

        if [[ -z "$ip" ]]; then
            echo "can't find connected vpn machine" >&2
            return 1
        fi

        uber-ssh:alias -s smart-ssh-tmux "$ip"
    }

    :ag() {
        ag -f --hidden --silent "${(j:.*?:)@}"
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
}

# autoloads
{
    autoload -U smart-insert-last-word
    autoload -U is_inside_git_repo
    autoload -U is_git_repo_dirty
    autoload -U is_rebase_in_progress
}

# widgets
{
    zle -N prepend-sudo prepend_sudo
    zle -N smart-insert-last-word-wrapper
    zle -N smart-insert-prev-word
    zle -N noop noop
    zle -N leap-back leap-back
}

# compdefs
{
    compdef systemctl-command-and-status=systemctl
    compdef _git-merge-with-rebase git-merge-with-rebase
    compdef man-search=man
    compdef vim-which=which
}

# bindkeys
{
    bindkey -v

    bindkey -v "^A" beginning-of-line
    bindkey -v "^[OA" hijack:history-substring-search-up
    bindkey -v "^[OB" history-substring-search-down
    bindkey -v "^[[3~" delete-char
    bindkey -v '^A' beginning-of-line
    bindkey -v '^E' end-of-line
    bindkey -v '^[[Z' reverse-menu-complete
    bindkey -v '^[d' delete-word
    bindkey -v '^K' add-params
    bindkey -v '^O' toggle-quotes
    bindkey -v '^ ' autosuggest-execute
    bindkey -v '^_' favorite-directories:cd
    bindkey -a '^[' vi-insert
    bindkey -a '^[d' delete-word
    bindkey -a '^[Od' backward-word
    bindkey -a '^[Oc' forward-word
    bindkey -a '^?' backward-delete-char
    bindkey -a '^H' backward-delete-char
    bindkey '^W' smart-backward-kill-word
    bindkey '^S' smart-forward-kill-word
    bindkey '^P' fuzzy-search-and-edit
    bindkey '^[Od' backward-word
    bindkey '^[Oc' forward-word
    bindkey '^[[5~' forward-word
    bindkey '^[[6~' backward-word
    bindkey "^T" prepend-sudo
    bindkey "^F" leap-back
    bindkey "\e." smart-insert-last-word-wrapper
    bindkey "\e," smart-insert-prev-word
    bindkey "^[[11^" noop
    bindkey '^R' fzf-history-widget

    bindkey -s '^Y' 'vim-select-file\n'
}

# hijacks
:hijack:load() {
    hijack:reset

    hijack:transform '^p([0-9]+)' \
        'sed -re "s/^.([0-9]+)/phpnode\1.x/"'

    hijack:transform '^t([0-9]+)' \
        'sed -re "s/^.([0-9]+)/task\1.x/"'

    hijack:transform '^f([0-9]+)' \
        'sed -re "s/^.([0-9]+)/frontend\1.x/"'

    hijack:transform '^d([0-9]+)' \
        'sed -re "s/^.([0-9]+)/dbnode\1.x/"'

    hijack:transform '^(ri|ya|fo)((no|pa|re|ci|vo|mu|xa|ze|bi|so)+)(\s|$)' \
        'sed -re "s/^(..)((..)+)(\s|$)/\1\2.x\4/"'

    hijack:transform '^([[:alnum:].-]+\.x)(\s+me)' \
        'sed -re "s/^([[:alnum:].-]+\\.x)(\s+me)/\1 -ls.seletskiy/"'

    hijack:transform '^([[:alnum:].-]+\.x)($|\s+[^-s][^lu])' \
        'sed -re "s/^([[:alnum:].-]+\\.x)($|\s+[^-s][^lu])/\1 sudo -i\2/"'

    hijack:transform '^(\w{1,3}) ! ' \
        'sed -re "s/^(\w{1,3}) ! /\1! /"'

    hijack:transform '^(\w+)( .*)!$' \
        'sed -re "s/(\w+)( .*)!$/\1!\2/"'

    hijack:transform '^[ct/]!? ' \
        'sed -r s"/([\\$<>{}&\\\"([!?)''#^])/\\\\\1/g"'

    hijack:transform '^c\\!' \
        'sed -re "s/^c\\\\! /c! /"'
}

# aliases
:aliases:load() {
    unalias -m '*'

    alias help=guess

    alias xdis='printf "Disconnecting from %s" $DISPLAY && export DISPLAY='

    alias v='vim'
    alias vi='vim'

    alias l='ls'
    alias ls='ls --color=auto'
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

    alias duty='cake --id 41882909 -L'

    alias //='true'

    alias lgs=':git:show-sources-status'

    alias s/=':sed-replace:interactive'

    alias x=':go:compile-and-run'

    alias np=':carcosa-new-password'

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
    alias f=':find'
    alias fd=':find-and-cd'

    alias ipa='ip a'

    alias vf='vim $(fzf)'
    alias vw='vim-which'

    alias dt='cd ~/sources/dotfiles && git status -s'
    alias de='cd ~/sources/dotfiles/.deadfiles && git status -s'
    alias kb=':knowledge-base ~/sources/kb'
    alias se='cd ~/.secrets && carcosa -Lc'

    alias pp='sudo pacman -S'
    alias pp!='yes | sudo pacman --force --noconfirm -S'
    alias ppy='sudo pacman -Sy'
    alias ppr='sudo pacman -R'
    alias pqo='pacman -Qo'
    alias pql='pacman -Ql'
    alias pqs='pacman -Qs'
    alias pqi='pacman -Qi'
    alias ppu='sudo pacman -U'
    alias pps='pacman -Ss'
    alias po='pkgfile'

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

    alias zr='. ~/.zshrc'
    alias za='vim -o ~/.zshrc -c "/^# aliases" -c "normal zt" && source ~/.zshrc'

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

    alias ck='mkdir-and-cd'

    alias cks='ck-source-dir'

    alias di!="cd $DOTFILES_PATH && git-smart-pull && ./bootstrap"
    alias du!="di! $DOTFILES_PROFILE"
    alias di="cd $DOTFILES_PATH && ./dotfiles install"
    alias db='dotfiles-bootstrap'

    alias aur='dotfiles-bootstrap-aur -S'

    alias godoc='godoc-less'

    alias man='man-search'

    alias m=':sources:clone github.com:seletskiy'
    alias k=':sources:clone github.com:kovetskiy'
    alias r=':sources:clone github.com:reconquest'
    alias d=':sources:clone git.rn:devops'
    alias s=':sources:clone git.rn:specs'
    alias n=':sources:clone git.rn:ngs'

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

    alias @=':heaver:list-or-attach "$HEAVERD_DEVELOPMENT"'
    alias @h=':heaver:find-host-by-container-name "$HEAVERD_DEVELOPMENT"'
    alias %=':heaver:list-or-attach "$HEAVERD_PRODUCTION"'
    alias %h=':heaver:find-host-by-container-name "$HEAVERD_PRODUCTION"'

    alias ns='nodectl:filter'
    alias nsp='nodectl:filter -pp'

    alias xp='orgalorg -spxl'
    alias xps='orgalorg:shell:with-password'
    alias xpc='xp -C'

    alias thr='thyme show -i ~/.thyme.json -w stats > /tmp/thyme.html &&
        xdg-open /tmp/thyme.html && rm /tmp/thyme.html'

    alias home=':ssh:find-and-connect-vpn-machine'

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
        alias k='git checkout'
        alias j='k master'
        alias j!='j && rst!'
        alias ju='j && u'
        alias r='git-smart-remote'
        alias e=':git:rebase-interactive'
        alias b='git branch'
        alias bm='git branch -m'
        alias h='git reset HEAD'
        alias i='git add -p'
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

if ! :is-interactive; then
    zle -R
fi
