HEAVERD_PRODUCTION='foci.cname.s:8081'
HEAVERD_DEVELOPMENT='container.s:8081'

alias @=':heaver:list-or-attach "$HEAVERD_DEVELOPMENT"'
alias @h=':heaver:find-host-by-container-name "$HEAVERD_DEVELOPMENT"'
alias %=':heaver:list-or-attach "$HEAVERD_PRODUCTION"'
alias %h=':heaver:find-host-by-container-name "$HEAVERD_PRODUCTION"'

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
