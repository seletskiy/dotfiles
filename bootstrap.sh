#!/bin/bash
# vim: set et ai sw=4 sts=4 ts=4:

install_from_aur() {
    local fname="$1"

    local pkgname=${a%/#*/}
    local path=$(sed -r 's#/((..).[^/]*)/$#/\2/\1/\1.tar.gz#' <<< "$fname")

    cd $(mktemp -d)
    curl -O "$path" | tar zx
    cd *
}

IFS=''
sed -n /^exit/,//p "$0" | while read line; do
    case "$line" in
        exit|\#*|"")
            continue
            ;;
        https://aur.*)
            echo "AUR $line"
            install_from_aur "$line"
            ;;
    esac
done

exit

# Real packages goes here.
# * packages from official repo specified with theirs name;
# * packages from aur specified with URL;
# * packages from github specified with URL;

https://aur.archlinux.org/packages/i3pystatus-git/
