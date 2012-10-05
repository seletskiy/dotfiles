XPTemplate priority=lang

let s:f = g:XPTfuncs()

XPTinclude
      \ _common/common

XPT fr " from ... import ...
from `module^ import `name^

XPT c " class
class `name^(`object^):
    `cursor^

XPT ini " def __init__
def __init__(self`, args?^):
    `cursor^

XPT s " self.
self.`cursor^

XPT d " def
def `method^(self`, args?^):
    `cursor^

XPT exc " class ...(Exception)
class `Name^(`Exception^):
    `pass^

`cursor^
