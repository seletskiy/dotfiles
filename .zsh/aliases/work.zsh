HEAVERD_PRODUCTION='foci.cname.s:8081'
HEAVERD_DEVELOPMENT='container.s:8081'

alias @=':heaver:list-or-attach "$HEAVERD_DEVELOPMENT"'
alias @h=':heaver:find-host-by-container-name "$HEAVERD_DEVELOPMENT"'
alias %=':heaver:list-or-attach "$HEAVERD_PRODUCTION"'
alias %h=':heaver:find-host-by-container-name "$HEAVERD_PRODUCTION"'

alias ns='nodectl -S'
alias nsp='nodectl -Spp'

:heaver:list-or-attach() {
    if [ $# -lt 2 ]; then
        :heaver:list-containers "$1"
    else
        :heaver:attach \
            "$(:heaver:find-host-by-container-name "$1" "$2")" \
            "$(:heaver:find-container-by-name "$1" "$2")"
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
        repos -AC -e "${3:-current}" "${2:-arch-ngs}" "/tmp/$1"
}

:repo:upload:old() {
    scp "$1" "repo.in.ngs.ru:/tmp/$1"
    ssh "repo.in.ngs.ru" -t sudo -i sh -s <<COMMANDS
        cd /data/repositories/ngs-packages/ && \
            mv -v /tmp/$1 ${2:-lucid}/ && \
            ./rescan_${2:-lucid}.sh
COMMANDS
}
