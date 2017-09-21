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
        }

        {
            zstyle ':smart-ssh' ssh 'ssh-urxvt'
        }

        {
            favorite-directories:get() {
                echo src 3 ~/sources 3
                echo zsh 2 ~/.zsh/.zgen 2
                echo vim 2 ~/.vim 2
                echo go 3 ~/go/src 3
            }
        }

        if :is-interactive; then
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

        {
            # https://github.com/sorin-ionescu/prezto/issues/1468#issuecomment-329265331
            bindkey ' ' self-insert
        }
    }

    {
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern hijack)
        ZSH_HIGHLIGHT_PATTERNS=('//*' 'fg=245')

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
            zgen load knu/zsh-manydots-magic
            zgen load brnv/zsh-too-long
            zgen load seletskiy/zsh-syntax-highlighting
            zgen load zsh-users/zsh-history-substring-search

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
    }
}

# bindkeys
{
    bindkey -e

    bindkey "^[[1~" beginning-of-line
    bindkey "^A" beginning-of-line
    bindkey '^[[A' hijack:history-substring-search-up
    bindkey '^[[B' hijack:history-substring-search-up
    #bindkey "^[OB" history-substring-search-down
    #bindkey "^[[B" history-substring-search-down
    bindkey "^[[3~" delete-char
    bindkey '^A' beginning-of-line
    bindkey '^[[4~' end-of-line
    bindkey '^E' end-of-line
    bindkey '^[[Z' reverse-menu-complete
    bindkey '^[d' delete-word
    bindkey '^K' add-params
    bindkey '^O' toggle-quotes
    bindkey -e '^_' favorite-directories:cd
    bindkey '^[d' delete-word
    bindkey '^[Od' backward-word
    bindkey '^[Oc' forward-word
    bindkey '^?' backward-delete-char
    bindkey '^H' backward-delete-char
    bindkey '^W' smart-backward-kill-word
    bindkey '^S' smart-forward-kill-word
    bindkey '^P' fuzzy-search-and-edit
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
    hijack:transform '^([[:alnum:].-]+@)?([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})' \
        'sed -re "s/^/ssh /"'

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
}

source ~/.zsh/aliases.zsh

if [[ -f .zshrc && "$PWD" != "$HOME" ]]; then
    printf "Sourcing local .zshrc...\n"

    source .zshrc
fi

if ! :is-interactive; then
    zle -R
fi
