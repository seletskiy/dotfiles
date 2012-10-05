XPTemplate priority=personal

XPTinclude
      \ _common/common

XPT c " class ..
XSET className|def=fileRoot()
class `className^
{
public:
    `className^(`ctorParam^);
    ~`className^();
    `className^(const `className^& cpy);
    `cursor^
protected:

private:

};

XPT ce " class ..
XSET className|def=fileRoot()
class `className^: `public^ `parentClass`
{
public:
    `className^(`ctorParam^);
    ~`className^();
    `className^(const `className^& cpy);
    `cursor^
protected:

private:

};

XPT pd " type method\(...\)
XSET type|def=void
`type^ `method^(`args^)` const ^;`cursor^

XPT prd " type _method\(...\)
XSET type|def=void
`type^ _`method^(`args^)` const ^;`cursor^


XPT pi " public: type method\(...\) { ... }
XSET className|def=fileRoot()
XSET type|def=void
`type^ `className^::`method^(`args^)` const ^
{
    `cursor^
}

XPT pri " protected: type _method\(...\) { ... }
XSET type|def=void
`type^ `className^::_`method^(`args^)` const ^
{
    `cursor^
}

XPT in " #include <...>
#include <`file^>

XPT ih " #include <...>
XSET file|def=fileRoot()
#include "`file^.h"

XPT inc " #include "..."
#include "`file^"

XPT i wrap=cursor " if \(...\) { ... }
if (`condition^) {
    `cursor^
}

XPT w wrap=cursor " while \(...\) { ... }
while (`condition^) {
    `cursor^
}

XPT for wrap=cursor " for \(...) { ... }"
XSET type|def=int
for (`type^ `i^ = `0^; `i^ < `len^; `i^`++^) {
    `cursor^
}

XPT main " int main\(...\)
int main(int argc, char* argv[])
{
    `cursor^
    return 0;
}

XPT tc " TEST \(...\)
TEST(`What^)
{
    `cursor^
}

XPT ts " SUITE \(...\)
SUITE(`Name^)
{
    `cursor^
}

XPT ch " CHECK \(...\)
CHECK(`cursor^);

XPT r " return ...
return `cursor^;

XPT rr " return ...
return;
