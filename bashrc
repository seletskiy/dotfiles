[ -z "$PS1" ] && return

# prompt string colored for each server
set_ps() {
    local whoami=$(whoami|cut -b1-3)
    local ps_fg_id=37
    local ps_fg_path=34
    local ps_bg=45
    local ps_sty_bold='\[\033[01m\]'
    local ps_sty_id='\[\033['$ps_fg_id';'$ps_bg'm\]'
    local ps_sty_path='\[\033[00m\]\[\033[01;'$ps_fg_path'm\]'
    local ps_sty_reset='\[\033[00m\]'
    if [ $UID -eq 0 ]; then
        export PS1="$ps_sty_bold\h$ps_sty_path\w$ps_sty_reset# "
    else
        export PS1="$ps_sty_bold$ps_sty_id$whoami@\h$ps_sty_path\w$ps_sty_reset\$ "
    fi
}

set_ps

# simple aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ls='ls --color=auto'
alias l='ls'
alias ll='ls -al'
alias less='less -R'
alias grep='grep --color'
alias g='grep'
alias ack='ack-grep'
alias vimdiff='vim -d'
alias wget="wget -P $HOME/downloads/"

# complex aliases
rm() { mkdir -p $HOME/trash/ && mv "${@}" $HOME/trash/ ; }

# exports
export HISTCONTROL=erasedups
export PATH=$HOME/bin:$PATH
export HISTSIZE=10000
export EDITOR=vim
export LC_ALL=en_US.utf-8

# term detection for ssh (rxvt-unicode is not supported wide)
if [ "$TERM" == "rxvt-unicode-256color" ]; then
    if [ "$SSH_TTY" ]; then
        export TERM=xterm-256color
    fi
fi

# ls colors for solarized theme
if [ -a "$HOME/.dir_colors_solarized" ]; then
    eval `dircolors $HOME/.dircolors-solarized`
fi

# shell options
shopt -s autocd
shopt -s histappend
shopt -s cdspell

# special keys bindings
bind '"\e[Z":menu-complete-backward'
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[7~": beginning-of-line'
bind '"\e[8~": end-of-line'
bind '"\eOc": forward-word'
bind '"\eOd": backward-word'

# do not search for unknown command in repos
unset command_not_found_handle
