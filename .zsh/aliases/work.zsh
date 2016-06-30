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

pdns:cname:new() {
    local name="$1"
    local address="$2"
    local domain=""

    IFS="." read -r domain suffix <<< "$name"

    local zone="${${suffix##*.}:-s}"
    local domain_id="$(pdns domains list -f id -n "$zone")"

    pdns records add -t CNAME -d "$domain_id" \
        -n "${address:-$domain.cname.$zone}" \
        -c "$name"
    pdns soa update -n "$zone"
}

pdns:a:new() {
    local name="$1"
    local address="$2"
    local domain=""

    IFS="." read -r domain suffix <<< "$name"

    local zone="${${suffix##*.}:-s}"
    local domain_id="$(pdns domains list -f id -n "$zone")"

    pdns records add -t A -d "$domain_id" -n "$name" -c "$address"
}

pdns:srv:new() {
    local name="$1"
    local hostname="$2"
    local port="${3:-80}"
    local domain=""

    IFS="." read -r domain suffix <<< "$name"

    local zone="${${suffix##*.}:-s}"
    local domain_id="$(pdns domains list -f id -n "$zone")"

    pdns records add -t SRV -d "$domain_id" -l 60 \
        -n "$domain.${suffix:-_tcp.s}" -c "0 $port $hostname"
    pdns soa update -n s
}

