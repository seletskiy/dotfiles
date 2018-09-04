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

    HISTSIZE=30000
    HISTFILE=~/.zsh/.zhistory
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
        'history' \
        'directory' \
        'completion'

}

# plugins
{
    zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

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
            if [[ ! -d $ZGEN_DIR/tarjoilija/zgen ]]; then
                git clone https://github.com/tarjoilija/zgen.git \
                    "~/.zgen/tarjoilija/zgen"
            fi

            source $ZGEN_DIR/tarjoilija/zgen/zgen.zsh
        fi

        if :is-interactive; then
            zle() {
                if [[ "$1" == "-R" || "$1" == "-U" ]]; then
                    unset -f zle

                    compinit

                    :plugins:load
                    :plugins:post-init

                    :hijack:load
                    :aliases:load
                    :compdef:load

                fi

                builtin zle "${@}"
            }
        else
            :plugins:load
            :plugins:post-init
            :aliases:load
        fi
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
            setopt prompt_sp
            setopt inc_append_history
            setopt share_history
        }

        #{
        #    zstyle ':smart-ssh' ssh 'ssh-urxvt'
        #}

        {
            zle -N :favor
            bindkey '^N' :favor
            :favor() {
                local favor_dir="$(favor 2>/dev/null)"
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
            }
        }

        {
            FAST_HIGHLIGHT_CUSTOM_HIGHLIGHTERS+=(:highlight-comment)

            :highlight-comment() {
                local prefix=${BUFFER%% // *}
                if [[ "$BUFFER" != "$prefix" ]]; then
                    _zsh_highlight_apply_zle_highlight custom-comment \
                        "fg=238" "${#prefix}" "${#BUFFER}"
                fi
            }
        }

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

            {
                if [ ${+functions[manydots-magic]} -eq 0 ]; then
                    autoload -Uz manydots-magic
                    manydots-magic
                fi
            }
        fi

        {
            # https://github.com/sorin-ionescu/prezto/issues/1468#issuecomment-329265331
            bindkey ' ' self-insert
        }
    }

    {
        FAST_HIGHLIGHT_CUSTOM_HIGHLIGHTERS+=(:hijack:highlight)

        ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=(forward-char)
        ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(end-of-line)
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
        #zgen load kovetskiy/zsh-smart-ssh
        #zgen load seletskiy/zsh-ssh-urxvt
        zgen load seletskiy/zsh-context-aliases
        zgen load seletskiy/zsh-git-smart-commands
        zgen load seletskiy/zsh-hijack
        zgen load seletskiy/zsh-hash-aliases
        #zgen load seletskiy/zsh-uber-ssh
        zgen load deadcrew/deadfiles

        if :is-interactive; then
            {
                eval "$(sed -r -e 's/\+s//' -e '/bindkey/d' /usr/share/fzf/key-bindings.zsh)"
            }

            zgen load kovetskiy/zsh-alias-search
            zgen load seletskiy/zsh-ash-completion
            zgen load seletskiy/zsh-smart-kill-word
            zgen load kovetskiy/zsh-add-params
            zgen load kovetskiy/zsh-quotes
            zgen load knu/zsh-manydots-magic
            zgen load zsh-users/zsh-history-substring-search

            zgen load zdharma/fast-syntax-highlighting

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

        zstyle lambda17:05-sign text "α"
        zstyle lambda17:20-git left "┉"
        zstyle lambda17:01-git-stash text "⚑"
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
        compdef _:git:rebase-interactive :git:rebase-interactive
        compdef _:git:checkout-and-update :git:checkout-and-update
        compdef _:git:branch:delete :git:branch:delete
    }
}

# bindkeys
{
    bindkey -e

    bindkey "^[[1~" beginning-of-line
    bindkey "^A" beginning-of-line
    #bindkey '^[[A' hijack:history-substring-search-up
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

    bindkey -s '^Y' 'vim-select-file\n'
}

# hijacks
:hijack:load() {
    hijack:reset

    hijack:transform ' // .*' \
        'sed -re "s# // .*##"'

    hijack:transform '^(\w{1,3}) ! ' \
        'sed -re "s/^(\w{1,3}) ! /\1! /"'

    hijack:transform '^(\S+)(\s.*)!$' \
        'sed -re "s/(\w+)( .*)!$/\1!\2/"'

    hijack:transform '^[ct]!? |^/[g]? ' \
        'sed -r s"/([\\$<>{}&\\\"([!?)''#^])/\\\\\1/g"'

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
}

source ~/.zsh/aliases.zsh

if [[ -f .zshrc && "$PWD" != "$HOME" ]]; then
    printf "Sourcing local .zshrc...\n"

    source .zshrc
fi

if ! :is-interactive; then
    zle -R
fi
