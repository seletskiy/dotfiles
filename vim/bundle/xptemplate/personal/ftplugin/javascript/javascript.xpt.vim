XPTemplate priority=personal

XPTinclude
      \ _common/common

let s:f = g:XPTfuncs()

XPT i wrap=cursor " if \(...\)
if (`condition^) {
    `cursor^
}

XPT e wrap=cursor " else ...
else {
    `cursor^
}

XPT f wrap=cursor hint=function () {}
function (`args^) {
    `cursor^
}

XPT cl wrap=cursor hint=closure
(function (`local^) {
    `cursor^
})(`global^)

XPT r
return `cursor^;

XPT rn
return null;

XPT rf
return false;

XPT rt
return true;

XPT rr
return;

XPT v
var `var^ = `default^;`cursor^

XPT t
this.`cursor^
