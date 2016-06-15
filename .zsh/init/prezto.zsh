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
