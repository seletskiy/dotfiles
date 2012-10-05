XPTemplate priority=personal

XPTinclude
      \ _common/common

XPTembed
      \ html/html

let s:f = g:XPTfuncs()

XPTvar $DATE_FMT     '%d/%m/%Y'

fun! s:f.PHPAddField_getVarName()
    return g:PHPAddField_name
endfun

fun! s:f.PHPAddField_jumpBack()
    exec "imap <TAB> <C-O>:call g:PHPAddField_jumpBack()<CR>"
    return ''
endfun

fun! s:f.getLevelsDownToTestHelper()
    let path = expand('%:p:r')
    let levels = '/'
    if stridx(path, '/tests/') > -1
        let hierarhy = matchlist(path, '\v/tests/(.*)')[1]
        let hierarhy = substitute(hierarhy, '\v[^/]', '', 'g')
        for i in range(len(hierarhy))
            let levels = levels . '../'
        endfor
        return levels
    else
        return 'levels'
    endif
endfun

fun! s:f.buildPathToTestedClass()
    if len(s:f.R('className')) > 0
        let className = s:f.R('className')
    else
        let className = ''
    endif

    let testcaseName = substitute(s:f.R('category') . '_' . s:f.R('package') . className, 'Test', '', 'g')
    return substitute(testcaseName, '\v_', '/', 'g') . '.php'
endfun

fun! s:f.getTestcaseName()
    if len(s:f.R('className')) > 0
        let className = s:f.R('className')
    else
        let className = ''
    endif

    return s:f.R('category') . '_' . s:f.R('package') . className . 'Test'
endfun

fun! s:f.classNameFromPath()
    let path = expand('%:p:r')
    if (stridx(path, '/scripts/') > -1)
        let hierarhy = matchlist(path, '\v/scripts/(.*)')[1]
        return substitute(hierarhy, '/', '_', 'g')
    else
        return 'className'
    endif
endfun

fun! s:f.parentClassNameFromClass()
	let className = s:f.R('className')

	if len(className) > 0
		return join(split(className, '_')[:-2], '_')
	else
		return 'parent'
	endif
endfun

fun! s:f.phpdocCategoryFromClass()
	let className = s:f.R('className')

	if len(className) > 0
		return split(className, '_')[0]
	else
		return 'category'
	endif
endfun


fun! s:f.phpdocPackageFromClass()
	let className = s:f.R('className')

	if len(className) > 0
		return split(className, '_')[1]
	else
		return 'package'
	endif
endfun


fun! s:f.modelTableNameFromClass()
	let className = s:f.R('className')

	if len(className) > 0
		let ic = &ignorecase
		let &ignorecase = 0
		return substitute(substitute(split(className, '_')[-1], '\<\@!\([A-Z]\)', '\_\l\1', 'g'), '^\([A-Z]\)', '\l\1', '')
		let &ignorecase = ic
	else
		return 'tableName'
	endif
endfun


fun! s:f.getParentMethod()
    let cur = [line('.'), col('.')]
    normal [[
    let start = line('.')
    call search('\v(^\s*\{|\)\s*\{)')
    let end = line('.')
    let signature = join(getline(start, end), ' ')
    call cursor(cur[0], cur[1])
    let method = matchlist(signature, '\v(public|protected|private) function (\w+)(\(.*\))')
    let name = method[2]
    let args = method[3]
    let argStart = 0
    let argsList = []
    while 1
        let arg = matchlist(args,
                    \ '\v((\w+\s+)?\s*(\$\w+)(\s*\=\s*((\").{-}[^\\](\\*)\7\6|[^,]+))?\s*,?)',
                    \ argStart)
        if arg == []
            break
        endif
        let argStart += len(arg[0])
        let argVar = substitute(arg[3], '^\s+|\s+^', '', 'g')
        let argsList += [argVar]
    endwhile

    return [name, argsList]
endfun

fun! s:f.getParentMethodName()
    let [name, _] = s:f.getParentMethod()
    return name
endfun

fun! s:f.getParentMethodArgs()
    let [_, args] = s:f.getParentMethod()
    return join(args, ', ')
endfun


XPT bla
var `ModuleName^ = require('`ModuleName^');`cursor^

XPT c " class { ... }
XSET className|def=classNameFromPath()
XSET ComeFirst=className description category package copy
`:@@c:^
class `className^
{
    `cursor^
}

XPT ce " class { ... }
XSET className|def=classNameFromPath()
XSET ComeFirst=className description category package copy
`:@@c:^
class `className^ extends `parent^
{
    `cursor^
}

XPT cm " class Model { ... }
XSET className|def=classNameFromPath()
XSET parent|def=parentClassNameFromClass()
XSET category|def=phpdocCategoryFromClass()
XSET package|def=phpdocPackageFromClass()
XSET tableName|def=modelTableNameFromClass()
XSET copy|def=NGS
XSET ComeFirst=className
`:@@c:^
class `className^ extends `parent^
{
    /**
     * Инициализирует таблицы модели.
     */
    protected function _init()
    {
        $this->_addTable('`tableName^');
    }


    `cursor^
}

XPT pa " parent::method\(...\)
XSET method|def=getParentMethodName()
XSET args|def=getParentMethodArgs()
parent::`method^(`args^);

XPT cn " public function __construct\(...\)
XSET method|def=__construct
`:p:^

XPT i wrap=cursor " if \(...\) { ... }
if (`condition^) {
    `cursor^
}

XPT f wrap=cursor " foreach \($l as $v\) { ... }
XSET list|def=$list
XSET item|def=$item
foreach (`list^ as `item^) {
    `cursor^
}

XPT fk wrap=cursor " foreach \($l as $k => $v\) { ... }
XSET list|def=$list
XSET key|def=$key
XSET item|def=$item
foreach (`list^ as `key^ => `item^) {
    `cursor^
}

XPT t " $this->_
$this->_`cursor^

XPT p " public function method\(...\)
XSET ComeFirst=method args
`:@@m:^
public function `method^(`args^)
{
    `cursor^
}

XPT pr " protected function method\(...\)
XSET ComeFirst=method args
`:@@m:^
protected function _`method^(`args^)
{
    `cursor^
}

XPT pri " private function method\(...\)
XSET ComeFirst=method args
`:@@m:^
private function _`method^(`args^)
{
    `cursor^
}

XPT pro " protected $_var
XSET ComeFirst=var null
`:@@v:^
protected $_`var^` = `null`^;

XPT priv " private $_var
XSET ComeFirst=var null
`:@@v:^
private $_`var^` = `null`^;

XPT @@v
/** @var `type^ `description^ */

XPT @@m
/**
 * `description^`
 * `more...{{^
 *` `params...{{^
 * `:@p:^` `param...{{^
 * `:@p:^` `param...^`}}^`}}^`
 * `return...{{^
 * `:@r:^`}}^`}}^
 */


XPT @a " @author Me
@author      Stanislav Seletskiy <s.seletskiy@office.ngs.ru>

XPT @p " @param ...
@param `type^ `name^ `description^

XPT @r " @return ...
@return `type^ `description^

XPT @t " @throws ...
@throws `type^ `description^

XPT @i " @ignore 
@ignore

XPT @t " @todo ...
@todo `:Date:^: `message^

XPT @@f " file php-doc
/**
 * `description^
 *
 * @category    `category^
 * @package     `category^_`package^
 * @author      Stanislav Seletskiy <s.seletskiy@office.ngs.ru>
 * @copyright   `:Year:^ `copy^
 */


XPT @@c " class php-doc
/**
 * `class description^
 *
 * @category    `category^
 * @package     `category^_`package^
 * @author      Stanislav Seletskiy <s.seletskiy@office.ngs.ru>
 * @copyright   `:Year:^ `copy^
 */

XPT pro_auto 
XSET var|def=PHPAddField_getVarName()
XSET cursor|post=PHPAddField_jumpBack()
`:@@v:^
`protected^ $`var^` = `null`^;`cursor^

XPT rq " require_once ...
XSET ComeFirst=path
/** @see `cname^S(S(R('path'), '/', '_'), '\.\w\+$', '')^ */
require_once "`path^";

XPT r " return ...
return `value^;

XPT rr " return;
return;

XPT rt " return true;
return true;

XPT rf " return false;
return false;

XPT rn " return null;
return null;

XPT a wrap=cursor " array\(\)
array(`^)`cursor^

XPT a0 " array\(...\)
array(
    `value^,`...^
    `value^,`...^)

XPT aa " array\(...\)"
array(
    '`key^' => `value^,`...^
    '`key^' => `value^,`...^)

XPT emp wrap=what " empty\(...\)
empty(`what^)`cursor^

XPT ie wrap=cursor " if empty
if (empty(`what^)) {
    `cursor^
}

XPT irf " if ... \{ return false \}
if (`what^) {
	return false;
}

XPT ierf " if empty\(...\) \{ return false \}
if (empty(`what^)) {
	return false;
}

XPT ini wrap=cursor " if !isset
if (!isset(`what^)) {
    `cursor^
}

XPT ii wrap=cursor " if isset
if (isset(`what^)) {
    `cursor^
}

XPT in wrap=cursor " if not
if (!`what^) {
    `cursor^
}

XPT e wrap=cursor " else {...}
else {
    `cursor^
}

XPT ei wrap=cursor " elseif {...}
else`:i:^

XPT co wrap=what " count \(...\)
count(`what^)`cursor^

XPT li wrap=cursor " list \(...\)
list(`args^) = `cursor^;

XPT isa wrap=var " is_array\(...\)
is_array(`var^)`cursor^

XPT ina wrap=what " in_array\(...\)
in_array(`what^, `where^)`cursor^

XPT am " array_merge\(...\)
array_merge(`arr1^, `arr2^)`cursor^

XPT iss wrap=var " isset\(...\)
isset(`var^)`cursor^

XPT te wrap=var " isset\(...\) ? ... : ..."
isset(`var^) ? `var^ : `another^

XPT isn wrap=var " is_null\(...\)
is_null(`var^)`cursor^

XPT tc " testcase ...
XSET levels|def=getLevelsDownToTestHelper()
XSET parent|def=PHPUnit_Framework_TestCase
XSET path|def=buildPathToTestedClass()
XSET className|def=S(fileRoot(), 'Test$', '', '')
XSET fullClassName|def=getTestcaseName()
XSET ComeFirst=description category package copy levels className parent
`:@@f:^

/** Test helper. */
require_once dirname(__FILE__) . '`levels^TestHelper.php';

`:rq:^

/**
 * Для запуска отдельного тесткейса.
 * @ignore
 */
// @codingStandardsIgnoreStart
if (!defined('PHPUnit_MAIN_METHOD')) {
    define('PHPUnit_MAIN_METHOD', '`fullClassName^::main');
}
// @codingStandardsIgnoreEnd

`:@@c:^
class `category^_`package^`_`className`^Test extends `parent^
{
    public static function main()
    {
        $suite = new PHPUnit_Framework_TestSuite(__CLASS__);
        $result = PHPUnit_TextUI_TestRunner::run($suite);
    }


    public function setUp()
    {
        
    }


    public function tearDown()
    {
        
    }


    `cursor^
}

/**
 * Для запуска отдельного тесткейса.
 * @ignore
 */
// @codingStandardsIgnoreStart
if (PHPUnit_MAIN_METHOD == '`fullClassName^::main') {
    `fullClassName^::main();
}
// @codingStandardsIgnoreEnd



XPT tm " public function test...
public function test`Action^()
{
    `cursor^
}

XPT ae " assertEquals
$this->assertEquals(`expected^, `actual^);

XPT v wrap=var " var_dump\(...\)
var_dump(`var^);`cursor^

XPT ve wrap=var " error_log\(var_export\(..., 1\)\)"
error_log(var_export(`var^, 1));`cursor^

XPT at " assertTrue
$this->assertTrue(`expression^);

XPT tr wrap=what " try { ... } catch \(...\) { ... }
try {
    `what^
} catch(`class^Exception $e) {
    `cursor^
}

XPT th " throw new Exception\(...\)
throw new `Exception^(`message^);

XPT s " $_SERVER[...]
$_SERVER['`key^']

XPT sa " $this->_smarty->assign
XSET value|def=$value
$this->_smarty->assign('`key^', `value^);
