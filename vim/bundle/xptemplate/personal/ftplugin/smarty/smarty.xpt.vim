XPTemplate priority=personal

XPTinclude
      \ _common/common
      \ html/html

"XPTembed

let s:f = g:XPTfuncs()

XPT i wrap=cursor " {if}
{if `condition^}
`cursor^
{/if}

XPT el wrap=cursor " {else}
{else}
`cursor^

XPT e " {$...}
{$`var^}

XPT em wrap=cursor " empty\(...\)
empty(`cursor^)
