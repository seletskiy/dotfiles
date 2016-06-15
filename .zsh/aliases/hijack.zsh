hijack:reset
hijack:transform 'sed -re "s/^p([0-9]+)/phpnode\1.x/"'
hijack:transform 'sed -re "s/^f([0-9]+)/frontend\1.x/"'
hijack:transform 'sed -re "s/^(ri|ya|fo)((no|pa|re|ci|vo|mu|xa|ze|bi|so)+)(\s|$)/\1\2.x\4/"'
hijack:transform 'sed -re "s/^([[:alnum:].-]+\\.x)(\s+me)/\1 -ls.seletskiy/"'
hijack:transform 'sed -re "s/^([[:alnum:].-]+\\.x)($|\s+[^-s][^lu])/\1 sudo -i\2/"'
hijack:transform 'sed -re "s/^(\w{1,3}) ! /\1! /"'

hijack:transform 'sed -re "s/(\w+)( .*)!$/\1!\2/"'

hijack:transform '^[ct]!? ' 'sed -r s"/([<>{}&\\\"([!?)''^])/\\\\\1/g"'
hijack:transform 'sed -re "s/^c\\\! /c! /"'
