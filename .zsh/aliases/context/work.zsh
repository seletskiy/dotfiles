context-aliases:match "find  -maxdepth 1 -name '*.tar.xz' | grep -q ."
    alias pu=":repo:upload:repos \$(ls -1t --color=never *.tar.xz | head -n1)"

context-aliases:match "find -maxdepth 1  -name '*.deb' | grep -q ."
    alias pu=":repo:upload:old \$(ls -1t --color=never *.deb | head -n1)"
