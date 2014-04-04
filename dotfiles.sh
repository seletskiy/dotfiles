#!/bin/bash
# vim: set et ai sw=4 sts=4 ts=4:

ensure_dir() {
    local dir=$1

    if [[ ! -d $dir ]]; then
        echo "dir: $dir"
        if [[ -e $dir || -h $dir ]]; then
            echo "file already exist: $dir"
            stat $dir
            exit 1
        fi

        mkdir -p $dir
        if [[ $? -gt 0 ]]; then
            echo "can not create dir: $dir"
            exit 2
        fi
    else
        if [[ "$(readlink -f $dir)" != "$dir" ]]; then
            echo "looks like '$dir' is a existing symlink to another dir"
            echo "readlink '$dir' = '$(readlink -f $dir)'"
            exit 3
        fi
    fi
}

install_file() {
    local file_name=$1
    local target_name=$2
    local symlink=1

    if [[ $target_name = /rootfs/* ]]; then
        target_name=${target_name##/rootfs}
        symlink=
        if [[ $EUID -gt 0 ]]; then
            echo "installing to $target_name requires sudo"
            return 1
        fi
    fi

    ensure_dir $(dirname $target_name)

    if [ "$(readlink -f $file_name)" = "$(readlink -f $target_name)" ]; then
        return 0
    fi

    diff -q $file_name $target_name &>/dev/null
    if [ $? -eq 0 ]; then
        return 0
    fi

    if [ "$symlink" ]; then
        echo "link: $file_name -> $target_name"
        ln -fTs $(readlink -f $file_name) $target_name
    else
        echo "cp: $file_name -> $target_name"
        cp $(readlink -f $file_name) $target_name
    fi
}

install_template() {
    local file_name=$1
    local target_name=$2
    local line=''

    if [[ -h $target_name ]]; then
        echo "$target_name is a symlink, remove it first"
        exit 1
    fi

    ensure_dir $(dirname $target_name)

    if [[ -e $target_name && -z "$force" ]]; then
        if [[ $(stat -c%Y $file_name) -le $(stat -c%Y $target_name) ]]; then
            return 1
        fi
    fi

    echo "generating: $target_name"

    (
        echo "### WARNING!"
        echo "### THIS FILE IS GENERATED BY DOTFILES INSTALL SCRIPT."
        echo "### DO NOT EDIT IT MANUALLY."
        echo "###"
        echo "### IF YOU WANT TO, PLEASE EDIT $file_name".
    ) > $target_name

    IFS=$'\n'
    for line in $(cat $file_name); do
        while true; do
            local placeholder=$(grep -o '{{[^}]*}}' <<< "$line")
            if [[ -z "$placeholder" ]]; then
                break
            fi

            local silent=$(grep -qi password <<< "$placeholder" && echo -s)

            read -p"$placeholder: " $silent value
            sed 's/-s//;t;d' <<< "$silent" >&2

            line=${line/$placeholder/$value}
        done
        echo $line
    done >> $target_name
}

if [[ "$HOME" = "/root" ]]; then
    echo "you should use -E flag to run as sudo"
    exit 1
fi

if [[ "$1" != "install" ]]; then
    echo 'Usage: [$placeholder=value ...] '$0' (install|help|-h|--help)'
    echo
    echo Known placeholders:
    echo '* $profile=work|home|laptop'
    exit 1
fi

IFS=$'\n'
placeholder_base=xxxx
for file_name in $(git ls-files); do
    base_dir=$([[ $file_name != rootfs/* ]] && echo ~)/

    case $file_name in
        *README*)
            # skip all readme
            ;;
        $(basename $0))
            # skip me
            ;;
        *.\$*)
            placeholder_base=$(sed 's/\.\$\w*$//' <<< $file_name)
            placeholder_value=$(eval echo $file_name)
            if [ "$placeholder_value" = "$placeholder_base". ]; then
                echo "placeholder variable is not set: $file_name"
                exit 1
            fi
            ;;
        $placeholder_value)
            install_file $file_name $base_dir$placeholder_base
            ;;
        $placeholder_base.*)
            ;;
        *.template)
            install_template $file_name $base_dir${file_name%%.template}
            ;;
        *)
            install_file $file_name $base_dir$file_name
            ;;
    esac
done
