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
    SSH_USERNAME=s.seletskiy

    KEYTIMEOUT=1

    AUTOPAIR_INHIBIT_INIT=1

    FZF_TMUX_HEIGHT=0
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
            source $ZGEN_DIR/tarjoilija/zgen/zgen.zsh
        fi

        zle() {
            if [[ "$1" == "-R" || "$1" == "-U" ]]; then
                unset -f zle

                :plugins:load
                :plugins:post-init

                :hijack:load
                :aliases:load
                :compdef:load
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
            unsetopt menu_complete
        }

        {
            zstyle ':smart-ssh' ssh 'ssh-urxvt'
        }

        {
            favorite-directories:get() {
                echo src 3 ~/sources
                echo core 1 ~/sources/core
                echo devops 1 ~/sources/devops
                echo zsh 2 ~/.zsh/.zgen
                echo vim 2 ~/.vim
                echo go 3 ~/go/src
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
            zgen load kovetskiy/zsh-alias-search
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

        if [[ "$ENCRYPTED" ]]; then
            zstyle 'lambda17:00-banner' bg 1
            zstyle 'lambda17:00-banner' fg 16
            zstyle 'lambda17:05-sign' fg 15
        fi
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
        compdef vim-which=which
    }
}

# bindkeys
{
    bindkey -e

    bindkey "^A" beginning-of-line
    bindkey "^[OA" hijack:history-substring-search-up
    bindkey "^[[A" hijack:history-substring-search-up
    bindkey "^[OB" history-substring-search-down
    bindkey "^[[B" history-substring-search-down
    bindkey "^[[3~" delete-char
    bindkey '^A' beginning-of-line
    bindkey '^E' end-of-line
    bindkey '^[[Z' reverse-menu-complete
    bindkey '^[d' delete-word
    bindkey '^K' add-params
    bindkey '^O' toggle-quotes
    bindkey '^ ' autosuggest-execute
    bindkey -e '^_' favorite-directories:cd
    bindkey '^[d' delete-word
    bindkey '^[Od' backward-word
    bindkey '^[Oc' forward-word
    bindkey '^?' backward-delete-char
    bindkey '^H' backward-delete-char
    bindkey '^W' smart-backward-kill-word
    bindkey '^S' smart-forward-kill-word
    bindkey '^P' fuzzy-search-and-edit
    bindkey '^[Od' backward-word
    bindkey '^[Oc' forward-word
    bindkey '^[[5~' forward-word
    bindkey '^[[6~' backward-word
    bindkey "^T" prepend-sudo
    bindkey "^F" leap-back
    bindkey "^G" alias-search
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

    hijack:transform '^c([0-9]+)' \
        'sed -re "s/^.([0-9]+)/cachenode\1.x/"'

    hijack:transform '^d([0-9]+)' \
        'sed -re "s/^.([0-9]+)/dbnode\1.x/"'

    hijack:transform '^(ri|ya|fo)((no|pa|re|ci|vo|mu|xa|ze|bi|so)+)(\s|$)' \
        'sed -re "s/^(..)((..)+)(\s|$)/\1\2.x\4/"'

    hijack:transform '^([[:alnum:].-]+\.x)(\s+me)' \
        'sed -re "s/^([[:alnum:].-]+\\.x)(\s+me)/\1 -l'$SSH_USERNAME'/"'

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

    hijack:transform '^ ' \
        'sed -re "s/^ /cd /"'
}

source ~/.zsh/aliases.zsh

if ! :is-interactive; then
    zle -R
fi
