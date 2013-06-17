" no compatible with vi
set nocompatible

" basic vundle settings
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

Bundle 'gmarik/vundle'
"Bundle 'Raimondi/delimitMate'
Bundle 'kana/vim-smartinput'
Bundle 'nevar/revim'
Bundle 'tpope/vim-fugitive'
Bundle 'Gundo'
Bundle 'L9'
Bundle 'dahu/SearchParty'
Bundle 'matchit.zip'
Bundle 'scrooloose/nerdcommenter'
Bundle 'Rainbow-Parenthesis'
Bundle 'git@github.com:seletskiy/vim-refugi'
Bundle 'wojtekmach/vim-rename'
Bundle 'repeat.vim'
Bundle 'altercation/vim-colors-solarized'
Bundle 'surround.vim'
Bundle 'tpope/vim-unimpaired'
Bundle 'git@github.com:seletskiy/smarty.vim'
Bundle 'git@github.com:seletskiy/nginx-vim-syntax'
Bundle 'PHP-correct-Indenting'
Bundle 'git@github.com:seletskiy/Command-T'
Bundle 'Lokaltog/vim-powerline'
Bundle 'SirVer/ultisnips'
"Bundle 'scrooloose/syntastic'
Bundle 'epmatsw/ag.vim'
Bundle 'Valloric/YouCompleteMe'
Bundle 'airblade/vim-gitgutter'
Bundle 'lyokha/vim-xkbswitch'

" syntax on!
syntax on
" allow using filetype plugin detection and indenting
filetype plugin on
filetype indent on

fun! g:LightRoom()
    set background=light
    call s:ApplyColorscheme()
    hi underlined cterm=underline
    hi LineNr ctermfg=249 ctermbg=none
	hi SignColumn ctermfg=240 ctermbg=none
    hi Normal ctermbg=none
    hi TabLine ctermfg=1 ctermbg=7 cterm=none
    hi ColorColumn ctermbg=230

    hi TabLineFill ctermfg=1 ctermbg=7 cterm=none
    hi TabLineSel ctermbg=13 ctermfg=15 cterm=bold
    hi TabLineMod ctermbg=1 ctermfg=15 cterm=bold

    let g:Powerline_colorscheme = 'solarized'
    if exists(':PowerlineReloadColorscheme') == 2
        PowerlineReloadColorscheme
    endif
endfun

fun! g:DarkRoom()
    set background=dark
    call s:ApplyColorscheme()
    hi underlined cterm=underline
    hi LineNr ctermfg=238 ctermbg=none
	hi SignColumn ctermfg=240 ctermbg=none
    hi Normal ctermbg=none
    hi ColorColumn ctermbg=235

    hi TabLine ctermfg=247 ctermbg=236 cterm=none
    hi TabLineFill ctermfg=247 ctermbg=236 cterm=none
    hi TabLineSel ctermbg=148 ctermfg=22 cterm=bold
    hi TabLineMod ctermbg=1 ctermfg=15 cterm=bold

    let g:Powerline_colorscheme = 'default'
    if exists(':PowerlineReloadColorscheme') == 2
        PowerlineReloadColorscheme
    endif
endfun

fun! s:ApplyColorscheme()
    let g:solarized_termcolors = 256
    let g:solarized_contrast = 'high'
    colorscheme solarized
    hi! link WildMenu PmenuSel 
    hi erlangEdocTag cterm=bold ctermfg=14
    hi erlangFunHead cterm=bold ctermfg=4
endfun

if $BACKGROUND == 'light'
    call g:LightRoom()
else
    call g:DarkRoom()
endif

" editing in utf-8 by default
set encoding=utf-8

" printing in utf-8
set printencoding=cp1251

" 400 ms is enough bitwixt two key presses
set timeoutlen=400

" wildmenu is the best for selecting in command line
set wildmenu

" infinite undo
set undofile
set undodir=$HOME/.vim/tmp/
set directory=$HOME/.vim/tmp/

" really fast! do not really see difference...
set ttyfast

" autowrite on :! commands
set autowrite

" slow as hell!
set relativenumber

" hide without saving. why? i don't remember, really...
set hidden

" highlig
set hlsearch

" incremental search rules
set incsearch

" command line history length
set history=500

" ignore case when there are only lower letters in pattern
set smartcase

" do not expand tab by default
set noexpandtab

" smart, as ai
set autoindent

" indent width
set shiftwidth=4

" <tab> and <bs> length in insert mode
set softtabstop=4

" length of <tab> in spaces
set tabstop=4

" autocomplete list numbers
" autoinsert comment leader
" do not wrap line after oneletter word
set formatoptions=qrn1tol

" without folds it is better, really
set nofoldenable

" erase it all with fire!
set backspace=2

" show statusline always, it's so cuuuute ^_^
set laststatus=2

" use /g flag as default in search-n-replace
set gdefault

let g:XkbSwitchLib = '/usr/lib/libxkbswitch.so'
let g:XkbSwitchEnabled = 1

" WTF?
"set t_kB=[Z

" the <leader> key
let mapleader="\<space>"

cmap w!! %!sudo tee > /dev/null %
map <F12> :bufdo bd!<CR><BAR>:tabo<CR>:enew<CR>

" use <c-e> and <c-t> for autocompletion
imap <C-T> <C-O>:call search("[)}\"'`\\]]", "c")<CR><Right>

" one key press for one ident level
noremap > >>
noremap < <<

let g:Powerline_symbols = 'fancy'

let g:ycm_key_list_select_completion = ['<C-N>', '<Down>']

" useful search plugin from dahu
nmap <silent> <space><space> <Plug>SearchPartyHighlightClear
au BufEnter * hi SPM1 ctermbg=1 ctermfg=7
au BufEnter * hi SPM2 ctermbg=2 ctermfg=7
au BufEnter * hi SPM3 ctermbg=3 ctermfg=7
au BufEnter * hi SPM4 ctermbg=4 ctermfg=7
au BufEnter * hi SPM5 ctermbg=5 ctermfg=7
au BufEnter * hi SPM6 ctermbg=6 ctermfg=7

"let g:neocomplcache_enable_at_startup = 1
"inoremap <expr><CR> neocomplcache#smart_close_popup() . "\<CR>"
"if !exists('g:neocomplcache_keyword_patterns')
"    let g:neocomplcache_keyword_patterns = {}
"endif
"let g:neocomplcache_keyword_patterns['php'] = '</\?\%(\h[[:alnum:]_-]*\s*\)\?\%(/\?>\)\?\|\$\h\w*\|\h\w*\%(\%(\\\|::\)\w*\)*\%(()\?\)\?\|[а-я]\+'
""if !exists('g:neocomplcache_omni_patterns')
""  let g:neocomplcache_omni_patterns = {}
""endif
""let g:neocomplcache_omni_patterns.python = ''
""let g:neocomplcache_enable_fuzzy_completion = 1
""let g:neocomplcache_fuzzy_completion_start_length = 2
"inoremap <expr><C-y> neocomplcache#close_popup()

let g:CommandTUseGitLsFiles = 1
if &term =~ "screen" || &term =~ "xterm"
    let g:CommandTCancelMap     = ['<ESC>', '<C-c>']
endif

augroup hilight_over_80
    au!
    au VimResized,VimEnter * set cc= | for i in range(80, &columns) | exec "set cc+=" . i | endfor
augroup end

command! W silent w !sudo tee % > /dev/null <bar> e!

map <C-T> <Leader>t

let g:surround_102 = "\1function: \1(\r)"

augroup dir_autocreate
    au!
	autocmd BufWritePre * if !isdirectory(expand('%:h')) | call mkdir(expand('%:h'),'p') | endif
augroup end

let html_no_rendering=1

au FileType html set ft=htmldjango
au FileType sql set ft=mysql
au FileType tex :e ++enc=cp1251
au FileType tex syn on
au BufEnter /data/projects/*.conf set ft=nginx
au BufEnter /data/projects/*.conf syn on
au FileType * set expandtab
au FileType erlang set expandtab ts=4 sw=4
au FileType erlang set comments=:%%%,:%%,:%

augroup skeletons
    au!
    au BufNewFile *.php exec "normal I<?php\<ESC>2o"
    au BufNewFile *.py exec "normal I# coding=utf8\<CR>\<ESC>xxo"
    au BufNewFile rebar.config,*.app.src exec "normal I%% vim: et ts=4 sw=4 ft=erlang\<CR>\<ESC>xx"
augroup end

au BufEnter */data/projects/* set noexpandtab
au BufEnter Makefile set noexpandtab

map <ins> i<ins><esc>

noremap <leader>v V`]
noremap <leader>p "1p

nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

inoremap jj <ESC>
nnoremap ? ?\v
vnoremap ? ?\v
nnoremap / /\v
vnoremap / /\v
nnoremap <TAB> %
vnoremap <TAB> %
imap <silent> <S-TAB> <C-O><<
vmap <silent> <TAB> >gv
vmap <silent> <S-TAB> <gv
vmap <silent> > >gv
vmap <silent> < <gv

nnoremap j gj
nnoremap k gk

nnoremap <F1> <ESC>

nmap <F2> :w<CR>
imap <F2> <ESC><F2>

map <Leader>1 1gt
map <Leader>2 2gt
map <Leader>3 3gt
map <Leader>4 4gt
map <Leader>5 5gt
map <Leader>6 6gt
map <Leader>7 7gt
map <Leader>8 8gt
map <Leader>9 9gt

set completeopt-=preview

"let g:xptemplate_brace_complete = 0
"let g:xptemplate_key = '<C-\>'
"let g:xptemplate_nav_next = '<C-J>'
"let g:xptemplate_nav_cancel = '<ENTER>'
"let g:xptemplate_fallback = "<C-O>:call g:MyXPTfallback()<CR>"

"imap <TAB> <C-R>=g:MyExpandTab()<CR>
"smap <TAB> <C-J>
"vmap <TAB> <C-\>

"fun! g:MyExpandTab()
"    if col('.') > 0
"        let column = col('.') - 1
"    else
"        let column = 0
"    endif

"    let ln = strpart(getline('.'), 0, column)
"    let g:MyExpandTabPumWasVisible = pumvisible()
"    if pumvisible()
"        "call feedkeys("\<C-Y>")
"    endif
"    let is_string = 0
"    let stack = synstack(line("."), column)
"    if len(stack) > 0
"        for id in stack
"            if synIDattr(id, "name") =~ '\w\+String'
"                let is_string = 1
"            endif
"        endfor
"    endif
"    if ln =~ '\v\$\w*$|\[\w*$' || is_string
"        let x = b:xptemplateData
"        if x.renderContext.processing > 0
"            call feedkeys("\<C-J>")
"        else
"            call feedkeys("\<Plug>delimitMateS-Tab")
"            "call g:AutoCloseJumpAfterPair()
"        endif
"    else
"        call feedkeys("\<C-\>")
"    endif

"    return ""
"endfun

"fun! g:MyXPTfallback()
"    let ln = strpart(getline('.'), 0, col('.') - 1)
"    if ln =~ '\v^\s*$'
"        call feedkeys("\<TAB>", 'n')
"    else
"        let x = b:xptemplateData
"        "if g:MyExpandTabPumWasVisible
"        "    call feedkeys("\<C-J>")
"        "endif
"        if x.renderContext.processing > 0
"            call feedkeys("\<C-J>")
"        else
"            call feedkeys("\<Plug>delimitMateS-Tab")
"            "call g:AutoCloseJumpAfterPair()
"        endif
"    endif
"endfun

let g:myTabLine_Cache = {}

function! MyTabLine()
    let s = ''
    let t = tabpagenr()
    let i = 1
    while i <= tabpagenr('$')
        let buflist = tabpagebuflist(i)
        let winnr = tabpagewinnr(i)
        " let s .= '%' . i . 'T'
        let s .= (i == t ? '%1*' : '%2*')
        for bi in buflist
            if getbufvar(bi, "&modified") 
                let s .= '%#TabLineMod#'
                break
            else
                let s .= (i == t ? '%#TabLineSel#' : '%#TabLineNum#')
            endif
        endfor
        let s .= ' '
        let s .= i
        let s .= ' %*'
        let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
		let s .= ' '
        let bufnr = buflist[winnr - 1]
        let file = bufname(bufnr)
        let buftype = getbufvar(bufnr, 'buftype')
        if buftype == 'nofile' || strlen(file) == 0
            if file =~ '\/.'
                let file = substitute(file, '.*\/\ze.', '', '')
            endif
        else
            if !has_key(g:myTabLine_Cache, file)
                let g:myTabLine_Cache[file] = fnamemodify(file, ':p:.')
            endif
            let file = g:myTabLine_Cache[file]
            let splitted = split(file, '[/\\]')
            let file = ''
            if len(splitted) > 4
                let path = splitted[-5:-2]
            else
                let path = splitted[:-2]
            endif
            for part in path
                let file .= part[0]
            endfor
            if splitted != []
                let filename = splitted[-1]
            else
                let filename = ""
            endif
            if len(filename) > 10
                let filenameSplitted = split(filename, '\.\([^.]\+$\)\@=')
                if len(filenameSplitted) < 2
                    let extension = ''
                else
                    let extension = '.' . filenameSplitted[1]
                endif
                let name = filenameSplitted[0]
                let name = substitute(name, '\..*\.', '..', '')
                let name = name[0] . substitute(name[1:-2], '[aeyuio]', '', 'g') . name[-1:]
                let lastPart = name . extension
            else
                if len(filename) > 0
                    let lastPart = filename
                else
                    let lastPart = ''
                endif
            endif
            "if len(file) >= 8
            "    let file = file[0:2] . '..' . file[-2:]
            "endif
            if len(lastPart) > 0
                let file .= '/' . lastPart
            endif
        endif
        if file == ''
            let file = '[No Name]'
        endif
        let s .= file
        let s .= (i == t ? '%#TabLineSel#' : '%#TabLineFill#')
        let s .= ' '
        let i = i + 1
    endwhile
    let s .= '%T%#TabLineFill#%='
    let s .= (tabpagenr('$') > 1 ? '%999X' : '')
    return s
endfunction

set tabline=%!MyTabLine()
