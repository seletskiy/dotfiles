#!/bin/bash
# vim: set et ai sw=4 sts=4 ts=4:

install_from_aur() {
    local pkgurl="$1"
    local force="$2"

    local pkgname=$(sed -r 's#.*/([^/]+)/?$#\1#' <<< "$pkgurl")
    local tarurl=$(sed -r 's#/((..).[^/]*)/$#/\2/\1/\1.tar.gz#' <<< "$pkgurl")

    if `pacman -Qqs $pkgname >&/dev/null`; then
        [ $force -gt 1 ] || return
    fi

    echo "AUR $pkgurl"

    local tmpdir=$(mktemp -d)
    cd $tmpdir
    curl "$tarurl" | tar zx
    cd $pkgname || exit 1

    makepkg -rs --noconfirm
    sudo pacman -U $pkgname*.xz --noconfirm || exit 1

    rm -r $tmpdir
}

exec_command() {
    local cmd="${1##\$ }"
    local force="$2"

    echo "CMD $cmd"

    eval "$cmd" || exit 1
}

install_pkg() {
    local pkgname="$1"
    local force="$2"

    if ! `pacman -Qqu $pkgname >&/dev/null`; then
        [ $force -gt 1 ] || return
    fi

    echo "PKG $pkgname"

    sudo pacman -S $pkgname --noconfirm || exit 1
}

main() {
    local force=$(grep -- -f <<<"$1" | cut -b2- | wc -c)
    IFS=''
    sed -n /^exit/,//p "$0" | while read line; do
        local needed_force=$(grep -o '^!*' <<< "$line" | wc -c)
        if [ $force -lt $needed_force ]; then
            continue
        fi

        local line="${line#\!* }"
        case "$line" in
            exit|\#*|"") continue ;;

            https://aur.*) install_from_aur "$line" "$force" ;;
            \$*)           exec_command     "$line" "$force" ;;
            *)             install_pkg      "$line" "$force" ;;
        esac
    done
}

main "${@}"
exit

# Real packages goes here.
# * packages from official repo specified with theirs name;
# * packages from aur specified with URL;
# * packages from github specified with URL;
# * command should be prefixed with $;
# * if line begins with !, equal amount of -f should be specified on cmd line;

$ sudo pacman -Sy --noconfirm

ntp
! $ sudo timedatectl set-timezone Asia/Novosibirsk
! $ sudo ntpd -gq

https://aur.archlinux.org/packages/i3pystatus-git/
