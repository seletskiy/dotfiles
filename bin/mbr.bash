#!/bin/bash

#################################################################################
. <(sed -n 's/^#z85://p' "$0" | basenc -d --z85 | zstd -d) ## LIB V0.1 ZU22 #####
#z85:d77-b006Xz05&Lga[eO)v!12&qU9iu*hAVme>gBY2zv(ed3?pw=+NE:2MWM#o-N==Mk190X(i34Y
#z85:*glH.yiG/0{Tb0>23Hm+W9<+rm<L?UNLwg>gr4hVDG/)D0&1mzgT}UB/w[Wc=KC2}E5kxComQb>+
#z85:i<nMZwhoLCO$*aMS[{3pPM&RFK4!yaa/jUF2erTO9za*rX7vaQr/o>@ZOYJFLC%k*Gya:zZ+5<@+
#z85:kf^0bS9MhpjFUK9mMdYqal?70C0vhwlS/3^iTH28Xm]r0Fx])r/ROL!![PN93r!.*i9Cz[M$KhJ]
#z85:z4-ZU#IO4J2b)D-.h8a[AEXnYIFJtX$j9SiqKncR0{5S=*JQv/D<[YFlBJ{}6*IOy+(x.z1JwELY
#z85:DYL($nQ)!RZh4jIDoWZ=vDwA?j@fb*q-S1Rs#!Ji(T2v![-.U*vpuHGg8q@SSbSXO4V#Mv5}:d5a
#z85:vI>tYLZO3njI4]V3chnua!*2[n]%4TShm&91)<5+ZgQL&H?Rv^Vc+4O7&O7zb@t*{bSRgq(>^+BK
#z85:geSR3/SsOFJ6H)$E8El)MSL]k*2$NIq>b*cx)v}J4V!L*MFAl(WlH(Nfw=Rgv7]nY)0<eR9b[T1p
#z85:m=L.$g*X6vc@F/Fu82sdWSdPNDH+Y(KBB2#i?dtvD:=8qL7}z*mU/X8<ir:ngALoVG9}GfJ5
#################################################################################

host=mbrserver.com
port=6667
nick=GPT4
chan=#general

## IRC CLIENT ###################################################################

:net()  { :io net /dev/tcp/$host/$port; }
:send() { :log "$(:hi 31 "< $@")"; :net:io:w "$@"; }
:recv() { := $1 "$(:net:io:r | :tr:d $'\r')"; :log "$(:hi 32 "> ${!1}")"; }

:elp() {
    # :on:dm() { echo      $1: ${*:2}; }
    # :on:ch() { echo [$2] $1: ${*:3}; }

    :arg()   { <<<$msg :cut:f ' ' $@; }
    :arg::() { :arg $1 | :cut:b 1; }

    :who() { :arg:: 1 1 | :cut:f '!' 1 1; }

    :h:ping() { :send PONG $(:arg 2 1); :pong:io:w "+ PONG"; }

    :h:privmsg:dm() { :on:dm "$(:who)" "$(:arg:: 4)";             }
    :h:privmsg:ch() { :on:ch "$(:who)" "$(:arg 3 1)" "$(:arg:: 4)"; }

    tag=':!(\ )'

    while :recv msg; do
        case "$msg" in
            PING\ *)                 :h:ping;       ;;
            $tag\ PRIVMSG\ $nick\ *) :h:privmsg:dm; ;;
            $tag\ PRIVMSG\ '#'*)     :h:privmsg:ch; ;;
        esac
    done
}

:register() {
    :send NICK $nick && :pong:io:r
    :send USER $nick 0 '*' :$nick
}

:start() { :net; :io pong; :bg elp :elp; :register; :bg:elp:wait; }

## CUSTOM LOGIC #################################################################

:gpt() {
    local top=$(<<<${*:3} :/ '\+\+(\w+)\s' ||:)
    local msg=$([ -n "${top:-}" ] && <<<${*:3} :cut:f ' ' 2 || :: "${*:3}")

    <<<"[$1]: $msg" gpt ++:irc:mbr "++irc:mbr:$2${top:+:$top}" +in
}

:gpt:dm() { :send:multi "$1"        < <(:gpt "$1" "$1" "${@:2}"); }
:gpt:ch() { :send:multi "$2" "$1: " < <(:gpt "$1" "$2" "${@:3}"); }

:send:multi() { while read line; do :send PRIVMSG "$1" :"${2-}$line"; done; }

:on:dm() { :gpt:dm "$@"; }
:on:ch() { [[ "${@:3}" == "^$nick:"* ]] && :gpt:ch "$@" || :; }

:start
:send JOIN $chan
