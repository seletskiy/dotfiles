XPTemplate priority=personal

let s:f = g:XPTfuncs()

XPTinclude
      \ _common/common



XPT sub " sub .. { .. }
sub `fun_name^`$BRfun^{
    `cursor^
}
