zmodload zsh/zprof

# detect zsh -is
{
    if [ -t 0 ]; then
        :is-interactive() {
            return 0
        }
    else
        :is-interactive() {
            return 1
        }
    fi
}

# globals
{
    ZDOTDIR=~/.zsh
    ZGEN_DIR=$ZDOTDIR/.zgen/

    DOTFILES=~/.dotfiles/

    KEYTIMEOUT=1

    FZF_TMUX_HEIGHT=0
    READNULLCMD='hash-aliases:less-or-grep'
}

# environment
{
    _DISPLAY=$DISPLAY

    eval $(
        eval ${SUDO_USER:+sudo -iu $SUDO_USER} \
            DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS \
            systemctl --user show-environment \
                | sed "s/^/export /"
    )

    export DISPLAY=${_DISPLAY:-$DISPLAY}

    if [[ "$PATH_PREPEND" ]]; then
        export PATH=$PATH_PREPEND:$PATH
    fi

    unset _DISPLAY
}


{
    # wow, such integration! https://github.com/tarjoilija/zgen/pull/27
    ln -sfT $ZDOTDIR/.zgen/sorin-ionescu/prezto-master $ZDOTDIR/.zprezto

    zstyle ':prezto:*:*' case-sensitive 'yes'
    zstyle ':prezto:*:*' color 'yes'

    zstyle ':prezto:load' pmodule \
        'editor' \
        'environment' \
        'terminal' \
        'directory' \
        'completion'

    HISTSIZE=300000

    if :is-interactive; then
        SAVEHIST=$HISTSIZE
    fi

    HISTFILE="$HOME/.zsh/.zhistory"

    setopt bang_hist
    setopt extended_history
    setopt inc_append_history
    #setopt share_history
    setopt hist_expire_dups_first
    setopt hist_ignore_dups
    setopt hist_ignore_all_dups
    setopt hist_find_no_dups
    setopt hist_ignore_space
    setopt hist_save_no_dups
    setopt hist_verify
    setopt hist_beep
    setopt rm_star_silent
}

# plugins
{
    {
        if ! :is-interactive; then
            compinit() { : }
            compdef()  { : }
            stty()     { : }
        fi

        # unless, zsh will crash with core dumped
        if ! type zgen >/dev/null 2>&1; then
            if [[ ! -d $ZGEN_DIR/tarjoilija/zgen ]]; then
                git clone https://github.com/tarjoilija/zgen.git \
                    $ZGEN_DIR/tarjoilija/zgen
            fi

            source $ZGEN_DIR/tarjoilija/zgen/zgen.zsh
        fi

        zle() {
            if [[ "$1" == "-R" || "$1" == "-U" ]]; then
                unset -f zle

                compinit

                :plugins:load
                :plugins:post-init

                :aliases:load

                if :is-interactive; then
                    :hijack:load
                    :compdef:load
                fi
            fi

            builtin zle "${@}"
        }
    }

    :plugins:post-init() {
        {
            zstyle ':completion:*' completer _expand _complete
            zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
        }

        {
            fpath=(${ZGEN_COMPLETIONS[@]} $fpath)
        }

        {
            unsetopt cdable_vars
            unsetopt correct
            unsetopt correct_all
            unsetopt global_rcs
            unsetopt menu_complete
            setopt prompt_sp
            unsetopt interactive_comments
        }

        #{
        #    zstyle ':smart-ssh' ssh 'ssh-urxvt'
        #}

        {
            zle -N :favor
            bindkey '^N' :favor
            :favor() {
                local favor_dir="$(favor)"
                if [[ ! "$favor_dir" ]]; then
                    return
                fi

                eval cd "$favor_dir"
                unset favor_dir

                clear
                zle -R
                # uncomment for lambda17 prompt compatibility
                lambda17:update
                zle reset-prompt
                context-aliases:on-precmd
            }
        }

        #{
        #    FAST_HIGHLIGHT_CUSTOM_HIGHLIGHTERS+=(:highlight-comment)

        #    :highlight-comment() {
        #        local prefix=${BUFFER%% // *}
        #        if [[ "$BUFFER" != "$prefix" ]]; then
        #            _zsh_highlight_apply_zle_highlight custom-comment \
        #                "fg=238" "${#prefix}" "${#BUFFER}"
        #        fi
        #    }
        #}

        if :is-interactive; then
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
        fi

        {
            # https://github.com/sorin-ionescu/prezto/issues/1468#issuecomment-329265331
            bindkey ' ' self-insert
        }
    }

    {
        ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=(forward-char)
        ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(end-of-line)
    }

    if :is-interactive; then
        alias compinit='compinit-zgen'
        function compinit-zgen() {
            grep -q ".zgen" <<< "${@}" && \compinit "${@}"
        }
    fi

    if ! zgen saved; then
        zgen load sorin-ionescu/prezto
        zgen load mafredri/zsh-async

        zgen save

        zgen init
    fi

    :plugins:load() {
        #zgen load kovetskiy/zsh-smart-ssh
        #zgen load seletskiy/zsh-ssh-urxvt
        zgen load seletskiy/zsh-context-aliases
        zgen load seletskiy/zsh-git-smart-commands
        zgen load seletskiy/zsh-hash-aliases
        zgen load deadcrew/deadfiles

        #zgen load seletskiy/zsh-uber-ssh

        if :is-interactive; then
            {
                eval "$(sed -r -e 's/\+s//' -e '/bindkey/d' /usr/share/fzf/key-bindings.zsh)"
            }

            zgen load seletskiy/zsh-hijack
            zgen load kovetskiy/zsh-alias-search
            zgen load seletskiy/zsh-ash-completion
            zgen load seletskiy/zsh-smart-kill-word
            zgen load kovetskiy/zsh-add-params
            zgen load kovetskiy/zsh-quotes

            unsetopt interactive_comments

            zgen load zdharma/fast-syntax-highlighting

            zgen load zsh-users/zsh-history-substring-search
            HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=""

            zgen load zsh-users/zsh-autosuggestions && _zsh_autosuggest_start

            functions[hijack:_zsh_highlight]=$functions[_zsh_highlight]

            zstyle 'hijack:highlighting' style 'bg=16,fg=255'

            _zsh_highlight() {
                # XXX: disable re-highlight on finish since it doesn't play well with lambda17 conceal
                # TODO: understand how to make re-highlight on zle-line-finish play well with lambda17
                if [[ $WIDGET == zle-line-finish ]]; then
                    return
                fi

                if ! :hijack:highlight; then
                    hijack:_zsh_highlight
                fi
            }

            # AWS
            {
                autoload bashcompinit && bashcompinit
                complete -C /usr/share/aws-cli/v2/*/bin/aws_completer aws
            }

            :bindkeys
        fi
    }
}

if :is-interactive; then
    # prompt
    {
        fpath+=(~/.zsh/.zgen/seletskiy/zsh-prompt-lambda17-master)
        zgen load seletskiy/zsh-prompt-lambda17

        autoload -Uz promptinit && promptinit

        prompt lambda17

        zstyle "lambda17:00-banner" bg "2"
        zstyle "lambda17:05-sign" text "111"
        zstyle "lambda17:01-git-stash" text "⚑"
        zstyle "lambda17:01-git-stash" fg "1"
        zstyle "lambda17:01-git-behind" fg "0"
        zstyle "lambda17:01-git-ahead" fg "0"
        zstyle "lambda17::terminal" bg "234"
        zstyle "lambda17:00-main" fg 241
        zstyle "lambda17:01-dir-writable" text "♦"
        zstyle "lambda17:26-git-dirty" text "∙"

        zstyle -d "lambda17:00-main" bg

        zstyle -d "lambda17>00-tty>00-root>00-main>00-status>00-banner" 05-sign
        zstyle -d "lambda17>00-tty>00-root>00-main>00-status" 00-banner
        zstyle -d "lambda17>00-tty>00-root>00-main>00-status" 09-arrow
        zstyle -d "lambda17>00-tty>00-root>00-main>20-git"
        zstyle -d "lambda17>00-tty>00-root>00-main>90-command"

        zstyle "lambda17>00-tty>00-root>00-main>00-status" \
            20-flags lambda17:panel
        zstyle "lambda17>00-tty>00-root>00-main" \
            10-arrow lambda17:panel

        zstyle "lambda17:10-dir" omit-empty true
        zstyle "lambda17:10-dir" fg 250
        #zstyle -d "lambda17:00-main" transform

        zstyle "lambda17>00-tty>00-root>00-main>00-status>20-flags" \
            26-git-dirty lambda17:text
        zstyle "lambda17>00-tty>00-root>00-main>00-status>20-flags" \
            01-dir-writable lambda17:text
        zstyle "lambda17>00-tty>00-root>00-main>00-status>20-flags" \
            25-head lambda17:git-head
        zstyle "lambda17>00-tty>00-root>00-main>10-arrow" \
            99-arrow-ok lambda17:text
        zstyle "lambda17>00-tty>00-root>00-main>10-arrow" \
            99-arrow-fail lambda17:text

        zstyle "lambda17:99-arrow-ok" text "❱"
        zstyle "lambda17:99-arrow-ok" when '[[ $_lambda17_exit_code -eq 0 ]]'
        zstyle "lambda17:99-arrow-ok" fg 240

        zstyle "lambda17:99-arrow-fail" text "❱"
        zstyle "lambda17:99-arrow-fail" when '[[ $_lambda17_exit_code -ne 0 ]]'
        zstyle "lambda17:99-arrow-fail" fg "red"

        zstyle "lambda17:25-head" fg-detached "220"

        zstyle "lambda17:00-main::conceal:override" ribbon " "

        zstyle -d "lambda17:00-main::conceal" weak

        zstyle "lambda17:00-main::conceal:override" format \
            '%B%K{$_lambda17_badge_color}%f${${${PWD#$HOME}##*/}:+╸${${PWD#$HOME}##*/}} %B%F{236}${padding}%b%k%F{$_lambda17_badge_color}%f '

        _lambda17_badge_color=125
        preexec() {
            _lambda17_badge_color=$((
                ($_lambda17_badge_color == 125) * 164 +
                ($_lambda17_badge_color == 164) * 125
            ))
        }

        zstyle "lambda17:00-main::conceal:override" right-justify false
        zstyle "lambda17:00-main::conceal:override" right \
            ' %F{240}%k╍ %F{220}%T%f'

        zstyle "lambda17:15-pwd" text '${${${PWD#$HOME}##*/}:+╸${${PWD#$HOME}##*/}} '
    }

    # ctrl-q
    {
        stty -ixon
    }
else
    PS1=""
fi

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
    :compdef:load() {
        compdef systemctl-command-and-status=systemctl
        compdef _git-merge-with-rebase git-merge-with-rebase
        compdef man-search=man
        compdef mark=cat
        compdef exa=ls
        compdef :vim-which=which
        compdef _:git:rebase-interactive :git:rebase-interactive
        compdef _:git:checkout-and-update :git:checkout-and-update
        compdef _:git:branch:delete :git:branch:delete
    }
}

# bindkeys
:bindkeys() {
    bindkey -e

    bindkey "^[[1~" beginning-of-line
    bindkey "^A" beginning-of-line
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
    bindkey "^[[3~" delete-char
    bindkey '^A' beginning-of-line
    bindkey '^[[4~' end-of-line
    bindkey '^E' end-of-line
    bindkey '^[[Z' reverse-menu-complete
    bindkey '^[d' delete-word
    bindkey '^K' add-params
    bindkey '^O' toggle-quotes
    bindkey '^[d' delete-word
    bindkey '^[Od' backward-word
    bindkey '^[Oc' forward-word
    bindkey '^?' backward-delete-char
    bindkey '^H' backward-delete-char
    bindkey '^W' smart-backward-kill-word
    bindkey '^S' smart-forward-kill-word
    bindkey "^T" prepend-sudo
    bindkey "^F" leap-back
    bindkey "^G" alias-search
    bindkey "^[[11^" noop
    bindkey '^R' fzf-history-widget
}

# hijacks
:hijack:load() {
    bindkey '^[[A' hijack:history-substring-search-up

    hijack:reset

    #hijack:transform '// .*' \
    #    'sed -re "s# // .*##"'

    #hijack:transform '^(\w{1,3}) ! ' \
    #    'sed -re "s/^(\w{1,3}) ! /\1! /"'

    hijack:transform '^(\S+)(\s.*)!$' \
        'sed -re "s/(\w+)( .*)!$/\1!\2/"'

    hijack:transform '^c#?!? |^@ |^=|^\+\+ ' \
        'sed -r "s/([\\$<>{}&\\\"([!?)''#^*;|])/\\\\\1/g" \
            | sed -r ''s/^c\\#/c#/'''

    #hijack:transform '^/[0-9]* ' \
    #    'sed -r -e "s/^\/([0-9]+)/\/ -C \1/" -e "s/([\\$<>{}&\\\"([?)''^*;|])/\\\\\0/g"'

    hijack:transform '^=' \
        'sed -r s"/^=(\S)/calc \1/g"'

    hijack:transform '^c\\!' \
        'sed -re "s/^c\\\\! /c! /"'

    hijack:transform '^ ' \
        'sed -re "s/^ /cd /"'

    hijack:transform '^https://github.com/' \
        'sed -re "s#^https://github.com/([^/]+/[^/]+)#gh \1#"'

    hijack:transform '^https://gitlab.com/' \
        'sed -re "s#^https://gitlab.com/([^/]+/[^/]+)#gl \1#"'

    hijack:transform '^https://' \
        'sed -re "s#^https://#curl -sLO &#"'

    hijack:transform '(\s+|=)j`' \
        'sed -r -e "s#(\s+|=)j?\`\*\s*#\1\"\$(jo -a #g" \
                -e "s#(\s+|=)j?\`\s*#\1\"\$(jo #g" \
                -e "s#\`#)\"#g"'
}

:aliases:load() {
    unalias -m '*'

    alias -- @='command log'

    alias ...='cd ../..'
    alias ....='cd ../../..'

    alias sudo='sudo '

    alias v='vim'
    alias vi='vim'

    alias ls='ls --color=auto'
    alias l='exa -la -snew' # --color-scale --grid'
    alias lt='l -T --level=2'

    alias rf='rm -rf'

    alias cu='curl -LO'

    alias skr='ssh-keygen -R'

    alias i='image-upload'

    alias -g '//'='; :'

    alias '%'=':sed-replace:interactive'
    alias '%j'='() { :sed-replace:interactive "$1" "$2" **/*.java; }'

    alias u='usb-shell'

    alias cnp=':carcosa:new-password'
    alias cap=':carcosa:add-password'

    alias re='rebirth'
    alias rg='rebirth gorun'
    alias !='() {
        zshi ''() { while eval "$(fc -ln -2 -2)"; do (( $1 > 0 )) && (( i += 1 )) && (( i >= $1 )) && exit; done; }'' "${1:-0}"
    }'

    alias ji='() {
        if [ "$1" ]; then
            batrak -L "$1"
        else
            jils
        fi
    }'

    alias 'ji?'='ji $(jid)'

    alias ji-='batrak -LKws'

    alias jils='() {
        batrak -Lw -q "${1:-status not in (''Done'', ''In Review'', ''Postponed'') and assignee = s.seletskiy or status in (''Backlog'', ''To Do'') and assignee is null}" -o "priority"
    }'
    alias jir='jils "status = ''In Review''"'
    alias jid='() {
        batrak -Lwm -q "status = ''${1:-In Progress}''" -o "priority" #h 1 #:1
    }'
    alias jimove='() {
        [ "$2" ] || set -- "$1" "$(jid)" && batrak -M "$2" "$1"
    }'
    alias jido='() {
        [ "$1" ] || set -- $(jid "To Do")
        batrak -A "$1"
        jimove 21 "$1"
        echo ---
        batrak -L "$1"
    }'
    alias jidone='jimove 31'
    alias jidone!='jimove 41'
    alias jio='() {
        [ "$1" ] || set -- $(jid)
        browser https://jira.reconquest.io/browse/$1
    }'
    alias jic='() {
        [ "$1" ] || set -- $(jid)
        batrak -C "$1"
    }'

    :unzip() {
        unzip "$1" -d "$(basename "$1" .zip)"
    }

    alias -s zip=':unzip'

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
    alias -- :j!='journalctl'
    alias -- :jf!=':j! -f'
    alias -- :ju!=':j! -u'
    alias -- :jfu!=':j! -f -u'
    alias -- :y!='() {
        systemctl --user status "$(
            systemd-run --user "$@" 2>&1 | grep -Po "Running as unit: \\K.*"
        )"
    }'

    alias -- :c!=':! cat'

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
    alias -- :ju=':j -u'
    alias -- :jfu=':j -f -u'
    alias -- :c=':: cat'

    alias -- +x='chmod-alias'

    alias /='AG_ARGS=--no-color :ag'
    #alias /g='AG_ARGS=--go :ag'
    #alias /rb='AG_ARGS=--rb :ag'
    alias f='() { find -iname "*$1*" "${@:2}" }'

    alias ipa='ip a'

    alias vw='(){ :vim-which "${@}" }'

    alias dt='cd $DOTFILES && git status -s'
    alias de='cd $DOTFILES/.deadfiles && git status -s'
    alias se='cd ~/.secrets && carcosa -Lc | sort'

    alias pp='sudo pacman -S'
    alias pp!='yes | sudo pacman --force --noconfirm -S'
    alias ppy='sudo pacman -Sy'
    alias ppyu='sudo pacman -Syu'
    alias ppr='sudo pacman -R <<< "y"'
    alias pq='pacman -Q'
    alias pqo='pacman -Qo'
    alias pql='pacman -Ql'
    alias pqs='pacman -Qs'
    alias pqi='pacman -Qi'
    alias ppu='sudo pacman -U'
    alias pps='pacman -Ss'
    alias pf='pacman -F'
    #alias po='pkgfile'
    #alias ppo='() { pp "$(po "$1")" }'
    alias ppyu='sudo pacman -Syu'
    alias ppyuz='ppyu --ignore linux,zfs-linux,zfs-utils-linux,spl-linux,spl-utils-linux'

    alias zgu='zgen update && zr'

    alias psx=':ps-grep'

    #alias goi='go install'
    #alias gob='go-fast-build'
    #alias gog='go get'
    #alias gogu='gog -u'

    alias 1='watch -n1'
    alias wt=':watcher:guess'
    alias -- --='wt --'

    alias vrc='vim ~/.vimrc'
    alias ze='exec zsh -i'
    alias zrc='vim ~/.zshrc'
    alias zre='zrc && ze'
    alias zr='source ~/.zshrc'
    alias snip='() {
        cd ~/.vim/bundle/snippets
        if [[ "$1" ]]; then
            vim $1.snippets
        else
            vim
        fi
    }'

    alias rto='rtorrent "$(ls --color=never -t ~/downloads/*.torrent \
        | head -n1)"'

    alias ck='() { mkdir -p $1 && cd $1 }'
    alias ct='() { cd $(mktemp -d) }'

    alias di!="cd $DOTFILES && git-smart-pull && ./bootstrap"
    alias du!="di! $DOTFILES_PROFILE"
    alias di="cd $DOTFILES && ./dotfiles install"

    alias pkg='yaourt --noconfirm -S'

    alias godoc='godoc-less'

    alias man='man-search'

    alias m=':sources:clone github.com:seletskiy'
    alias k=':sources:clone github.com:kovetskiy'
    alias r=':sources:clone github.com:reconquest'

    alias mgp=':sources:move-to-gopath'

    alias gc='git clone'
    alias gh=':sources:clone github.com:'
    alias gl=':sources:clone gitlab.com:'

    alias xc=':orgalorg:command'

    alias -- '-'=':pipe:tar'

    alias -- '+?'=':todoist list'
    alias -- '+.'=':todoist close'
    alias -- '+!'=':todoist sync'
    alias -- '+#'='() { :todoist add -p 4 "$*" }'
    alias -- '++'='() { :todoist add -N stack -p 4 "$*" }'

    alias ua='find -maxdepth 1 -mindepth 1 -type d |
        cut -b3- |
        while read -n dir; do
            ( cd $dir; [ -d .git ] && git pull --rebase |& prefix "{$dir} "; )
        done'

    alias 8='ping 8.8.8.8'

    alias xi='xclip -selection clipboard -i'
    alias xo='xclip -selection clipboard -o'
    alias xip='() { readlink -nf "$@" | xi }'

    alias -g -- '#i'='| xclip -selection clipboard -i'
    alias -g -- '#j'='| () { [ -t 1 ] && local flag="-C"; jq $flag "${@:-.}" # }'
    alias -g -- '#!'='# -v'
    alias -g -- '#+'='| paste -sd+ | bc'
    alias -g -- '#:1'='#f 1'
    alias -g -- '#~'='| () { awk "\$$1 ~ ${(qqq)${(@)*:2}}" }'
    alias -g -- '#t'='| tail -n'

    alias kub='skube'
    alias kaf='kub apply -f'
    alias kdf='kub delete -f'
    alias kc='kub create'
    alias kcn='kc namespace'
    alias kcs='kc secret'
    alias kdp='kub delete pods'
    alias kbb='kub run -i --tty --image alpine:edge busybox-$RANDOM --restart=Never --rm'
    alias kg='kub get'
    alias kgm='kg namespaces'
    alias kgn='kg nodes'
    alias kgd='kg deployments'
    alias kgp='kg pods'
    alias kgp!='kgp --all-namespaces'
    alias kgc='kg configmap'
    alias kgcy='kg -o yaml configmap'
    alias kgs='kg svc'
    alias kgi='kg ing'
    alias kd='kub delete'
    alias kp='() { kgp "${@:2}" -o name | cut -f2- -d/ | grep -F ${1}; }'
    alias kl='kub logs'
    alias klf='() { kl "${@}" -f --tail=50 }'
    alias ke='kub exec'
    alias kei='() { ke "$@" -it }'
    alias ksh='() { ke "$@" -it -- sh -i }'
    alias kcu='kub config use-context'
    alias kff='kub port-forward'
    alias ks='kub describe'
    alias ksp='ks pod'
    alias kss='ks svc'
    alias ksi='ks ing'
    alias mks='minikube start --cpus 1 --memory 1024'
    alias mks!='minikube stop'
    alias mke='eval $(minikube docker-env)'
    alias ked='kub edit'
    alias ktn='kub top nodes'
    alias ktp='kub top pods'

    alias pk='pkill -f'

    alias x=':context:command magalix'
    alias mk=':context:command minikube'

    alias rtorrent=':rtorrent'

    alias cci='circleci-cli --token-file ~/.config/circleci-cli/token'

    alias ssh!='rf ~/.ssh/connections/* && ssh'
    alias ssha='() {
        eval "$(ssh-agent -s)"
        ssh-add
        ssh -A "$@"
    }'

    alias len='() { echo -n "$*" | wc -c }'

    alias gb='gcloud builds'
    alias gbs='gb list'
    alias gbl='gb log --stream'

    alias wifi!='wifi !'

    alias tx='() {
        local session="$(
            tmux ls -F "#{session_attached} #{session_name}" \
                | awk "\$2 != \"-\"" \
                | awk "\$1 == 0 { print \$2 }" \
                | head -n1
        )"

        if [[ "$session" ]]; then
            TMUX= exec tmux at -t "$session"
        else
            echo "no inactive session found"
        fi
    }'

    alias txk!='() {
        tmux ls #! attached #:1 #td : #x tmux kill-session -t
    }'

    alias nocolor='sed -re ''s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g'''

    :http() {
        http --follow "${@}"
    }

    alias GET=':http GET'
    alias POST=':http POST'
    alias PUT=':http PUT'
    alias DELETE=':http DELETE'

    alias standup='() { vim "$@" && xi "$@" } work/standups/$(date +%F+%T)/standup'

    hash-aliases:install

    context-aliases:match is_inside_git_repo
        alias d='git diff'
        alias w='git diff --cached'
        alias a='git-smart-add'
        alias s='git status -s'
        alias o="git log --color=always --graph --all \
            --format='format:%C(yellow)%h%Cblue %cr %Cred%d %Creset%s' \
            --date=relative \
            | sed -re 's/([^/ ])(HEAD)/\\1\x1b[48;5;53;38;5;15;1m \\2 \x1b[0;31m/' \
            | sed -re 's/ ago //' \
            | less -RSX"
        alias c='git-smart-commit --verbose --amend'
        alias 'c#'='() { c $([ ! "$*" ] && echo --edit) "$(jid): $*" }'
        alias p='git-smart-push seletskiy'
        alias t='() { git tag -f "$@" }'
        alias t!='() { xargs -n1 <<< "$@" git tag -f && p -f "$@" }'
        alias k='git-smart-checkout --recurse-submodules'
        alias j='k master'
        alias j!='j && u'
        alias j!!='j && ur'
        alias ku=':git:checkout-and-update'
        alias r='git-smart-remote'
        alias e=':git:rebase-interactive'
        alias b='git branch'
        alias bm='git branch -m'
        alias bd!=':git:branch:delete'
        alias h='git reset HEAD'
        alias i='git add -p'
        alias ii=':git:commit:interactive'
        alias v='git mv'
        alias x!='git rm -rf'
        alias y='git show'
        alias ys='y --stat'
        alias q='git submodule update --init --recursive'
        alias n='git checkout -b'
        alias r='u && p'
        alias G='cd-pkgbuild'
        alias S='git stash -u && git stash drop'
        alias a!='git-smart-commit -a --amend'
        alias c!='git-smart-commit --amend'
        alias p!='git-smart-push seletskiy --force-with-lease  +`git symbolic-ref --short -q HEAD`'
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
        alias stp!='st pop'
        alias fk='hub fork'
        alias pr='hub pull-request'
        alias lk='github-browse'
        alias cln!='git clean -ffdx'
        alias cln='cln! -n'
        alias rst!='git reset --hard'
        alias mm='git-merge-with-rebase'
        alias me='git-remote-add-me'

        alias pr!='p && pr'

        alias au='git log --format=%aN | sort -u'
        alias fpr='() { git fetch origin pull/$1/head:pr-$1 && git checkout pr-$1 }'

        alias nox='() {
            git status -s \
                | awk "\$1 == \"??\" { print \$2 }" \
                | xargs -I{} sh -c "[ -x {} -a ! -d {} ] && rm -v {}"
        }'

        alias ur="() {
            u --prune
            git branch --format='%(refname:short) %(upstream:track)' \
                | awk '\$2 == \"[gone]\" { print \$1 }' \
                #x git branch -D
        }"

        #alias gg='() { git grep $1 $(git rev-list --all) -- ${@:2} }'
        alias -- +mod='() { GO111MODULE=on "${@}"}'

    context-aliases:match "test -e PKGBUILD"
        alias g='go-makepkg-enhanced'
        alias m='makepkg -f'
        alias mu='m && ppu'

        alias aur='push-to-aur'

        alias mb=':makepkg:branch'

    context-aliases:match "test -e Makefile"
        alias m='make -j8'
        alias mt='make test'

    context-aliases:match "test -e Taskfile.yml"
        alias m='task'

    context-aliases:match "is_inside_git_repo && is_git_repo_dirty"
        alias c='git-smart-commit'

    context-aliases:match "is_inside_git_repo &&
            \! git rev-parse HEAD &> /dev/null"
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

    context-aliases:match '[[ "$PWD" =~ ~/go/ ]]'
        alias got='go test -failfast'
        alias gob='go build'
        alias gtb='go test -run none -cpuprofile cpu.prof -bench'
        alias gtp='go tool pprof -nodecount 999 -png cpu.prof >| cpu.prof.png && \
            feh --scroll-step 100 cpu.prof.png'
        alias gtb!='() { gtb "${@}" && gtp; }'
        alias gtt='go tool pprof cpu.prof'
        alias x='gorun'

    context-aliases:commit
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

            if grep -qPx '\.?\w+\.\w+' <<< "$1"; then
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

            if grep -qP '^\./.+' <<< "$1"; then
                patterns+=("$1")
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
            command=("rebirth")
        fi

        if find -maxdepth 1 -name '*_test.go' | grep -q "."; then
            command=("go" "test" "-failfast")
        fi

        if run_tests=$(find . ./tests -maxdepth 1 -name 'run_tests*' 2>&-); then
            if [[ "$run_tests" ]]; then
                command=("$run_tests")
            fi
        fi

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
            patterns=("\.go$" "\.sh$" "\.py$" "\.amber$" "\.s?css$" "\.js$")
            message=("go" "sh" "py" "amber" "(s)css" "js")
        fi

        command+=("${options[@]}")

        if [[ ! "${command[@]}" ]]; then
            command=("rebirth")
        fi

        regexp="${(j:|:)patterns[@]}"

        printf "## watching %s files -> %s%s\n" \
            "${(j:, :)message[*]}" "${command[*]}" \
            "${timeout:+ (with ${timeout}s timeout)}"

        watcher -e close_write -t 0.5 \
            ${timeout:+-w$timeout} "$regexp" -- zshi "${command[@]}"
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
                    command nvim \
                        +"set noignorecase" +"Man $1" +only +"silent! /${2:1}"
                    return
                    ;;
                # search for flags description
                -*)
                    command nvim \
                        +"set noignorecase" +"Man $1" +only +"silent! /^\\s\\+\\zs${2}"
                    return
                    ;;
                # search for subcommand definition
                .*)
                    command nvim \
                        +"set noignorecase" \
                        +"Man $1" \
                        +only \
                        +"silent! /\\n\\n^[ ]\\{5,\\}\\zs${2:1}\\ze\( \|$\)"
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
                    command nvim \
                        +"set noignorecase" \
                        +"Man $1" \
                        +only \
                        +"silent! /^\(\\S\+.*\|\)\\zs${2:1:u}\\w*\\ze"
                    return
                    ;;
                *)
                    man-search "$1-$2" ${@:3}

                    return
                    ;;
            esac
        fi

        command nvim +"Man $MANSECT ${@}" +only
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
        local dir=$(dirs -p | tail -n+2 | fzf)
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
            git rebase -i "${@}"
        fi
    }

    _:git:rebase-interactive() {
        service="git-rebase" _git "${@}"
    }

    :git:checkout-and-update() {
        git checkout "${@}" && git-smart-pull --rebase
    }

    _:git:checkout-and-update() {
        service="git-checkout" _git "${@}"
    }

    push-to-aur() {
        local package_name="${1:-$(basename $(git rev-parse --show-toplevel))}"
        local package_name=${package_name%*-pkgbuild}
        local package_name=${package_name}-git

        git push ssh://aur@aur.archlinux.org/$package_name
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
        zparseopts -D -E -- C:=context A:=after B:=before
        ag $AG_ARGS -f --hidden --silent $context $after $before -- "${(j:.*?:)@}"
    }

    :ps-grep() {
        if [[ "${*}" ]]; then
            ps axfu | grep "${@}"
        else
            ps axfu | less
        fi
    }

    :git:commit:interactive() {
        local message
        while git add -p "${@}"; do
            if git diff --cached --quiet; then
                #highlight bold fg red
                printf ':: no changes detected\n'
                return 0
            fi

            #highlight bold fg yellow
            #printf ':: following changes will be commited\n'
            #highlight reset

            #git diff --cached

            #printf '\n'

            #message=$(grep -Po '^([^:]+:) ' <<< "$message")

            #local prompt=$(
            #    printf "%s%s: %s" \
            #        "$(highlight bold fg blue)" \
            #        "Commit message [empty to amend HEAD]" \
            #        "$(highlight reset)"
            #)

            #read "message?$prompt"

            git commit

            #if [[ "$message" ]]; then
            #    git commit -m "$message"
            #else
            #    git commit --amend -C HEAD
            #fi

            printf '\n'
        done
    }

    :git:branch:delete() {
        git branch -D "${@}"
        git push origin ":${^@}"
    }

    _:git:branch:delete() {
        service="git-branch" _git -D "${@}"
    }

    :pipe() {
        local pipe="/tmp/zsh.pipe"

        if [[ -t 0 ]]; then
            < "$pipe"
        else
            if [[ ! -p "$pipe" ]]; then
                mkfifo "$pipe"
            fi
            > "$pipe"
            rm "$pipe"
        fi
    }

    :pipe:tar() {
        if [[ "$*" ]]; then
            printf "%s\n" "$@" \
                | xargs -d'\n' -n1 readlink -f \
                | xargs -d'\n' -n1 printf "cp -vr %q .\n" \
                | :pipe
        else
            :pipe | xargs -d'\n' -n1 sh -c
        fi
    }

    :kubectl:file() {
        local command=$1
        shift

        kubectl $command "-f${^@}"
    }

    :context:command() {
        CONTEXT=$1 context-aliases:on-precmd

        shift

        eval "${(q)@}"
    }

    :todoist() {
        todoist --color "$@"
    }

    _autocd() {
        if [[ "${BUFFER:0:1}" == " " ]]; then
            CURRENT=$((CURRENT + 1))
            _cd
        else
            _command_names
        fi
    }

    :rtorrent() {
        sudo iptables -t nat -A OUTPUT -p tcp -m tcp --dport 80 -d 195.82.146.120/30 -j DNAT --to-destination 163.172.167.207:3128

        command rtorrent "$@"

        sudo iptables -t nat -D OUTPUT -p tcp -m tcp --dport 80 -d 195.82.146.120/30 -j DNAT
    }

    :vim-which() {
        if ! file="$(command which "$1" 2>/dev/null)"; then
            file=~/.dotfiles/bin/$1
        fi

        vim "$file"

        if [[ ! -x "$file" ]]; then
            chmod +x "$file"
        fi
    }
}

if ! :is-interactive; then
    zle -R
fi
