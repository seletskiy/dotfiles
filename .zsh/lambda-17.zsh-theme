PROMPT='%B%{[$LAMBDA_COLOR%}${LAMBDA_WRAP:-" "}$LAMBDA${LAMBDA_WRAP:-" "}%{$reset_color%} %b%~%(1/./.) $(git_prompt_info)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "

function zle-line-init zle-keymap-select {
    if [[ $KEYMAP == "vicmd" ]]; then
        export LAMBDA_WRAP="·"
    else
        export LAMBDA_WRAP=" "
    fi
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
