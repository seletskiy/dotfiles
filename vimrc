" Режим совместимости выключен
set nocompatible

"call pathogen#runtime_append_all_bundles()
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'Raimondi/delimitMate'
Bundle 'nevar/erlang-syntax'
Bundle 'tpope/vim-fugitive'
Bundle 'Gundo'
Bundle 'L9'
Bundle 'dahu/SearchParty'
Bundle 'matchit.zip'
Bundle 'Shougo/neocomplcache'
Bundle 'scrooloose/nerdcommenter'
Bundle 'Rainbow-Parenthesis'
Bundle 'git@github.com:seletskiy/vim-refugi'
Bundle 'wojtekmach/vim-rename'
Bundle 'repeat.vim'
Bundle 'altercation/vim-colors-solarized'
Bundle 'surround.vim'
Bundle 'tpope/vim-unimpaired'
Bundle 'git@github.com:seletskiy/xptemplate'
Bundle 'git@github.com:seletskiy/smarty.vim'
Bundle 'git@github.com:seletskiy/nginx-vim-syntax'
Bundle 'PHP-correct-Indenting'
Bundle 'wincent/Command-T'

set background=light
colorscheme solarized

" Кодировка по умолчанию
set encoding=utf-8
set penc=cp1251

set tm=400

" Изменение режима автодополения в командной строке
set wildmenu

" Хранение временных файлов и бесконечный UNDO
set undofile
set undodir=$HOME/.vim/tmp/
set directory=$HOME/.vim/tmp/

set ttyfast

"let g:showfuncctagsbin="ctags"
map <F3> :TlistToggle<CR>
au BufEnter *Tag_List* set nornu

map <F12> :bufdo bd!<CR><BAR>:tabo<CR>:enew<CR>

" Автозапись файла при запуске внешней программы
set autowrite

" Относительные номера строк (тормозит!)
set relativenumber

" Возможность скрывать буфферы без их сохранения
set hidden

" Подсветка поиска
set hls

" Клавиша <LEADER>
let mapleader="\<space>"

imap <C-E> <C-P>
imap <C-T> <C-N>

let delimitMate_matchpairs = "(:),[:],{:}"

nmap <silent> <space><space> <Plug>SearchPartyHighlightClear
au BufEnter * hi SPM1 ctermbg=1 ctermfg=7
au BufEnter * hi SPM2 ctermbg=2 ctermfg=7
au BufEnter * hi SPM3 ctermbg=3 ctermfg=7
au BufEnter * hi SPM4 ctermbg=4 ctermfg=7
au BufEnter * hi SPM5 ctermbg=5 ctermfg=7
au BufEnter * hi SPM6 ctermbg=6 ctermfg=7

let g:yankring_history_file = 'tmp/yankring.log'
let g:yankring_enabled = 1

let g:neocomplcache_enable_at_startup = 1
"let g:neocomplcache_enable_auto_select = 1
inoremap <expr><CR> neocomplcache#smart_close_popup() . "\<CR>"
if !exists('g:neocomplcache_keyword_patterns')
	let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['php'] = '</\?\%(\h[[:alnum:]_-]*\s*\)\?\%(/\?>\)\?\|\$\h\w*\|\h\w*\%(\%(\\\|::\)\w*\)*\%(()\?\)\?\|[а-я]\+'

set cc=
for i in range(80, 150)
    exec "set cc+=" . i
endfor

let g:fuf_coveragefile_exclude = '\v\~$|\.(o|exe|dll|bak|orig|swp|beam|pyc)$|TEST|(^|[/\\])\.(hg|git|bzr)($|[/\\])|doc/|tests/coverage/|erlang/releases/(files|reltool.config)\@!'

let g:EasyMotion_leader_key = '<Leader>'

set history=500

command! W silent w !sudo tee % > /dev/null <bar> e

map <C-T> <Leader>t

let g:surround_102 = "\1function: \1(\r)"

" Поиск в режиме игнорирования регистра
set ignorecase
set smartcase

set noexpandtab
set autoindent
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Распознавать списки, дополнять комментарии,
" не переносить строку после односимвольного слова
set formatoptions=qrn1tol

" Не сворачивать текст
set nofoldenable

" BS стирает все
set backspace=2

syntax on

command! -nargs=1 Sig !sig <args>
nmap <F4> :Sig

augroup dir_autocreate
	autocmd BufWritePre * if !isdirectory(expand('%:h')) | call mkdir(expand('%:h'),'p') | endif
augroup end

let html_no_rendering=1

"au FileType php inoremap {<CR> {<CR>}<C-O>O

let g:solarized_hitrail = 1
nnoremap + :call g:SolarizedHiTrailToggle()<CR>

set statusline=%<%f\ %h%m%r%=%-14.(%l,%v%)\ %P
set laststatus=2
set gdefault

set filetype=unix

au FileType html set ft=htmldjango
au FileType sql set ft=mysql
au FileType tex :e ++enc=cp1251
au FileType tex syn on
au BufEnter *.conf set ft=nginx
au BufEnter *.conf syn on
au FileType * set expandtab
au FileType erlang set expandtab ts=4 sw=4
au FileType erlang set comments=:%%%,:%%,:%

au BufNewFile *.php exec "normal I<?php\<C-O>2o"
au BufNewFile *.py exec "normal I# coding=utf8\<ESC>o\<BS>\<BS>\<ESC>o"
au FileType * runtime syntax/RainbowParenthsis.vim
au BufEnter */data/projects/* set noexpandtab

filetype plugin on
filetype indent on

set t_kB=[Z

set incsearch

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

let g:xptemplate_brace_complete = 0
let g:xptemplate_key = '<C-\>'
let g:xptemplate_nav_next = '<C-J>'
let g:xptemplate_nav_cancel = '<ENTER>'
let g:xptemplate_fallback = "<C-O>:call g:MyXPTfallback()<CR>"

hi erlangEdocTag cterm=bold ctermfg=14
hi erlangFunHead cterm=bold ctermfg=4

imap <TAB> <C-R>=g:MyExpandTab()<CR>
smap <TAB> <C-J>
vmap <TAB> <C-\>

inoremap <expr><C-y> neocomplcache#close_popup()

fun! g:MyExpandTab()
	if col('.') > 0
		let column = col('.') - 1
	else
		let column = 0
	endif

	let ln = strpart(getline('.'), 0, column)
	let g:MyExpandTabPumWasVisible = pumvisible()
	if pumvisible()
		"call feedkeys("\<C-Y>")
	endif
	let is_string = 0
	let stack = synstack(line("."), column)
	if len(stack) > 0
		for id in stack
			if synIDattr(id, "name") =~ '\w\+String'
				let is_string = 1
			endif
		endfor
	endif
    if ln =~ '\v\$\w*$|\[\w*$' || is_string
        let x = b:xptemplateData
        if x.renderContext.processing > 0
            call feedkeys("\<C-J>")
        else
            call feedkeys("\<Plug>delimitMateS-Tab")
            "call g:AutoCloseJumpAfterPair()
        endif
    else
        call feedkeys("\<C-\>")
    endif

    return ""
endfun

fun! g:MyXPTfallback()
    let ln = strpart(getline('.'), 0, col('.') - 1)
    if ln =~ '\v^\s*$'
        call feedkeys("\<TAB>", 'n')
    else
        let x = b:xptemplateData
		"if g:MyExpandTabPumWasVisible
		"    call feedkeys("\<C-J>")
		"endif
        if x.renderContext.processing > 0
            call feedkeys("\<C-J>")
        else
            call feedkeys("\<Plug>delimitMateS-Tab")
            "call g:AutoCloseJumpAfterPair()
        endif
    endif
endfun

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
                let s .= (i == t ? '%#TabLineSelMod#' : '%#TabLineMod#')
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
