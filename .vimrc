set nocompatible

if empty(glob('~/.vim/autoload/plug.vim'))
    silent !mkdir -p ~/.vim/autoload
    silent !curl -fLo ~/.vim/autoload/plug.vim
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/bundle')

let mapleader="\<space>"

Plug 'nevar/revim', {'for': 'erlang'}

Plug 'tpope/vim-fugitive'
    map <C-G><C-G> :Gstatus<CR>

Plug 'Gundo', {'on': 'GundoToggle'}

Plug 'dahu/SearchParty'
    nmap <silent> <Leader><Leader> :let @/="" \| call feedkeys("\<Plug>SearchPartyHighlightClear")<CR>

Plug 'edsono/vim-matchit', {'for': 'html'}

Plug 'scrooloose/nerdcommenter'

Plug 'kien/rainbow_parentheses.vim'

Plug 'wojtekmach/vim-rename'

Plug 'repeat.vim'

Plug 'junegunn/seoul256.vim'

Plug 'surround.vim'

Plug 'git@github.com:seletskiy/nginx-vim-syntax'

Plug 'PHP-correct-Indenting', { 'for': 'php' }

Plug 'Shougo/unite.vim'
    let g:unite_split_rule = "botright"
    let g:unite_source_history_yank_enable = 1
    let g:unite_enable_start_insert = 1
    let g:unite_source_history_yank_file = $HOME.'/.vim/yankring.txt'

    augroup unite_custom
        au!
        au VimEnter * call unite#custom#source(
            \ 'file,file/new,buffer,file_rec,file_rec/async,git_cached,git_untracked,directory',
            \ 'matchers', 'matcher_fuzzy')

        au VimEnter * call unite#custom#default_action(
            \ 'directory', 'cd')

        au VimEnter * call unite#filters#sorter_default#use(['sorter_selecta'])
    augroup end

    function! s:unite_my_settings()
        imap <buffer> <C-R> <Plug>(unite_redraw)
        imap <silent><buffer><expr> <C-T> unite#do_action('split')
        imap <silent><buffer><expr> <C-G> unite#do_action('right')
        call unite#custom#alias('ash_review', 'split', 'ls')
    endfunction

    let g:unite_source_grep_max_candidates = 200

    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '-i --line-numbers --nocolor --nogroup --hidden'
    let g:unite_source_grep_recursive_opt = ''

    map <C-P> :Unite -hide-source-names git_cached git_untracked buffer<CR>
    map <C-Y> :Unite -hide-source-names history/yank<CR>
    map <C-U> :Unite -hide-source-names buffer<CR>
    map <C-E><C-U> :Unite -hide-source-names buffer file_rec/async<CR>
    map <C-E><C-G> :Unite -hide-source-names grep:.<CR>
    map <C-E><C-H> <Leader>*:exec "Unite -hide-source-names grep:.::".substitute(@/, "\\\\<\\(.*\\)\\\\>", "\\1", "")."(?=\\\\W)"<CR>
    map <C-E><C-E> :Unite -hide-source-names directory:~/sources/<CR>
    map <C-E><C-A> :Unite ash_inbox<CR>
    map <C-E><C-R> :UniteResume<CR>

Plug 'Shougo/vimproc'

Plug 'yuku-t/unite-git'

Plug 'bling/vim-airline'
    let g:airline_powerline_fonts = 1
    let g:airline_theme = 'lucius'
    let g:airline#extensions#whitespace#symbol = '☼'

Plug 'seletskiy/matchem'
    " required to be setup before ultisnips inclusion
    let g:UltiSnipsJumpForwardTrigger = '<C-J>'
    let g:UltiSnipsJumpBackwardTrigger = '<C-K>'

    augroup fix_matchem_and_ultisnips
        au!
        " wow, \<lt>lt>c-o> will expand to \<lt>c-o> by feedkeys, and then to
        " <c-o> by matchem.
        au VimEnter * inoremap <expr> <C-O> (
            \ pumvisible()
                \ ? feedkeys("\<C-N>")
                \ : feedkeys("\<C-R>=g:MatchemRepeatFixupFlush('\<lt>lt>c-o>')\<CR>\<C-O>", 'n')
            \ ) ? '' : ''
    augroup end

Plug 'SirVer/ultisnips'
    let g:UltiSnipsSnippetDirectories = [$HOME.'/.vim/UltiSnips']
    let g:UltiSnipsEnableSnipMate = 0

    map <Leader>` :UltiSnipsEdit<CR>G
    vmap <Leader>` y:UltiSnipsEdit<CR>Go<CR>snippet HERE<CR>endsnippet<ESC>k]p?HERE<CR>zzciw

Plug 'epmatsw/ag.vim'

Plug 'Valloric/YouCompleteMe'
    let g:ycm_key_list_select_completion = ['<C-N>', '<Down>']
    let g:ycm_allow_changing_updatetime = 0
    let g:ycm_confirm_extra_conf = 1
    let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
    let g:ycm_collect_identifiers_from_comments_and_strings = 1

Plug 'lyokha/vim-xkbswitch'
    let g:XkbSwitchLib = '/usr/lib/libxkbswitch.so'
    let g:XkbSwitchEnabled = 1

Plug 'kristijanhusak/vim-multiple-cursors'

Plug 'fatih/vim-go', {'for': 'go'}
    let g:go_fmt_command = "goimports"
    let g:go_snippet_engine = "skip"

Plug 'kshenoy/vim-signature'
    let g:SignatureMarkOrder = "\m"

Plug 'vim-ruby/vim-ruby'

Plug 'michaeljsmith/vim-indent-object'

Plug 'xolox/vim-misc'

Plug 'cespare/vim-toml'

Plug 'osyo-manga/vim-over', {'on': 'OverCommandLine'}
    nnoremap H :OverCommandLine %s/\v<CR>
    vnoremap H :OverCommandLine s/\v<CR>

    map L <Leader>*:OverCommandLine %s//<CR>

Plug 'inkarkat/argtextobj.vim'

Plug 'kovetskiy/ash.vim'

Plug 'maksimr/vim-jsbeautify'

Plug 'seletskiy/vim-pythonx'

Plug 'justinmk/vim-sneak'
    let g:sneak#streak = 1

    nmap gs <Plug>Sneak_S
    vmap gs <Plug>Sneak_S

    nmap f <Plug>Sneak_f
    vmap f <Plug>Sneak_f
    nmap F <Plug>Sneak_F
    vmap F <Plug>Sneak_F

Plug 'kovetskiy/vim-plugvim-utils'

Plug 'seletskiy/vim-nunu'

Plug 'seletskiy/vim-over80'

syntax on

filetype plugin on
filetype indent on

call plug#end()

" Hack to ensure, that ~/.vim is looked first
set rtp-=~/.vim
set rtp^=~/.vim

" Wow, will it work?
set rtp-=/usr/share/vim/vimfiles

set encoding=utf-8
set printencoding=cp1251
set timeoutlen=200
set wildmenu
set undofile
set undodir=$HOME/.vim/tmp/
set directory=$HOME/.vim/tmp/
set ttyfast
set relativenumber
set hlsearch
set incsearch
set history=500
set smartcase
set expandtab
set autoindent
set shiftwidth=4
set softtabstop=4
set tabstop=4
set backspace=2
set laststatus=2
set gdefault
set completeopt-=preview
set nowrap
set updatetime=150
set showtabline=0
set cino=(s,m1,+0
set comments-=mb:*
set lazyredraw

" autocomplete list numbers
" autoinsert comment Leader
" do not wrap line after oneletter word
set formatoptions=qrn1tol

set list
set lcs=eol:¶,trail:·,tab:\ \  " <- trailing space here
set fcs=vert:│

let html_no_rendering=1

let g:EclimCompletionMethod = 'omnifunc'

" Ctrl+Backspace in cmd line
cmap <C-H> <C-W>
" Alt+d
cmap <Esc>d <S-Right><C-W>

imap <C-T> <C-R>=strpart(search("[)}\"'`\\]>]", "c"), -1, 0)<CR><Right>

imap <C-Y> u<TAB>

map <Leader>~ :tabnew ~/.vimrc<CR>

" there also ZZ mapping for snippets
map ZZ :w\|bw<CR>

noremap <Leader>v V`]
noremap <Leader>p "1p

nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-_> <C-W>_

nnoremap ? ?\v
vnoremap ? ?\v
nnoremap / /\v
vnoremap / /\v
vnoremap $ g_

nnoremap <TAB> %

noremap > >>
noremap < <<
imap <silent> <S-TAB> <C-O><<

nnoremap Q qq
nnoremap ! :g//norm @q<CR>
vnoremap ! :g//norm @q<CR>
vmap <expr> @ feedkeys(':norm @' . nr2char(getchar()) . "\<CR>")

vmap <silent> > >gv
vmap <silent> < <gv

map <C-D> $%

vmap ( S)i
vmap ) S)%a

inoremap jj <ESC>
nnoremap j gj
nnoremap k gk

inoremap <F1> <ESC>
nnoremap <F1> <ESC>
nmap <F2> :w<CR>
imap <F2> <ESC><F2>

map <Leader>3 :b #<CR>
map <Leader>c :cd %:h<CR>

cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>

map dsf dt(ds)

augroup review_setting
    au!
    au FileType diff nnoremap <buffer> <CR> o#<SPACE>
augroup end

augroup unite_setting
    au!
    au FileType unite call s:unite_my_settings()
augroup end

augroup erlang_indent
    au!
    au FileType erlang set indentexpr=""
    au BufEnter *.erl,rebar.config,*.hrl set ai
augroup end

augroup syntax_hacks
    au!
    au FileType diff set nolist
    au FileType diff call g:ApplySyntaxForDiffComments()
augroup end

augroup dir_autocreate
    au!
    au BufWritePre * if !isdirectory(expand('%:h')) | call mkdir(expand('%:h'),'p') | endif
augroup end

augroup skeletons
    au!
    " refactor with use of snippets
    au BufNewFile *.php exec "normal I<?php\<ESC>2o"
    au BufNewFile *.py exec "normal I# coding=utf8\<CR>\<ESC>xxo"
    au BufNewFile rebar.config,*.app.src exec "normal I%% vim: et ts=4 sw=4 ft=erlang\<CR>\<ESC>xx"

    au BufNewFile *.go call feedkeys("Ipa\<TAB>", "")
    au BufNewFile PKGBUILD call feedkeys("Ipkgbuild\<TAB>", "")
augroup end

augroup ft_customization
    au!
    au BufEnter php setl noexpandtab
    au FileType sql set ft=mysql
    au FileType tex :e ++enc=cp1251
    au BufEnter /data/projects/*.conf set ft=nginx
    au BufEnter /data/projects/*.conf syn on
    au FileType erlang setl comments=:%%%,:%%,:%
    au FileType php setl comments+=mb:*
augroup end

augroup go_src
    au!
    au FileType go setl noexpandtab
    au FileType nnoremap <buffer> K <Plug>(go-doc-vertical)
    au FileType go nmap <buffer> <Leader>r <Plug>(go-run)
    au FileType go map <buffer> <Leader>t <Plug>(go-test)
    au FileType go map <buffer> <Leader>b <Plug>(go-build)
    au BufRead,BufNewFile *.slide setfiletype present
augroup end

augroup vimrc
    au!
    au BufWritePost */.vimrc source % | AirlineRefresh
    au BufWritePost */.vim/pythonx/*.py exec printf('py import %s; reload(%s)',
                \ expand('%:t:r'),
                \ expand('%:t:r'))
augroup end

augroup snippets
    au!
    au FileType snippets map <buffer> ZZ :w\|b#<CR>
augroup end

augroup quickfix
    au!
    au FileType qf set wrap
augroup end

augroup rainbow
    au!
    au VimEnter * RainbowParenthesesActivate
    au Syntax * RainbowParenthesesLoadRound
    au Syntax * RainbowParenthesesLoadBraces
augroup end

augroup confluence
    au!
    au BufRead /tmp/vimperator-confluence* set ft=html.confluence | call HtmlBeautify()

    " trim empty <p><br/></p> from document
    au BufRead /tmp/vimperator-confluence* map <buffer> <Leader>t :%s/\v[\ \t\n]+\<p\>([\ \t\n]+\<br\>)?[\ \t\n]+\<\/p\>/<CR>

    " ugly hack to trim all inter-tags whitespaces
    au BufWritePre /tmp/vimperator-confluence* %s/\v\>[\ \t\n]+\</></
    au BufWritePost /tmp/vimperator-confluence* silent! undo
augroup end

com! BufWipe silent! bufdo! bw | enew!

command! QuickFixOpenAll call QuickFixOpenAll()
function! QuickFixOpenAll()
    if empty(getqflist())
        return
    endif
    let s:prev_val = ""
    for d in getqflist()
        let s:curr_val = bufname(d.bufnr)
        if (s:curr_val != s:prev_val)
            exec "edit " . s:curr_val
        endif
        let s:prev_val = s:curr_val
    endfor
endfunction

fun! g:LightRoom()
    set background=light
    let g:seoul256_background = 255
    call s:ApplyColorscheme()
    hi underlined cterm=underline
    hi CursorLineNr ctermfg=241 ctermbg=none
    hi LineNr ctermfg=249 ctermbg=none
    hi SignColumn ctermfg=none ctermbg=none
    hi ColorColumn ctermbg=15
    hi SpecialKey term=bold cterm=bold ctermfg=1 ctermbg=none
    hi NonText ctermfg=254 cterm=none term=none
    hi IncSearch cterm=none ctermfg=238 ctermbg=220

    hi Cursor ctermbg=0 ctermfg=15
    hi PmenuSel ctermbg=136 ctermfg=15 cterm=bold
endfun

fun! g:DarkRoom()
    set background=dark
    let g:seoul256_background = 234
    call s:ApplyColorscheme()
    hi underlined cterm=underline
    hi CursorLineNr ctermfg=242 ctermbg=none
    hi LineNr ctermfg=238 ctermbg=none
    hi SignColumn ctermfg=none ctermbg=none
    hi ColorColumn ctermbg=233
    hi SpecialKey term=bold cterm=bold ctermfg=1 ctermbg=none
    hi NonText ctermfg=235 cterm=none term=none
    hi IncSearch cterm=none ctermfg=238 ctermbg=220

    hi Cursor ctermbg=15 ctermfg=0
    hi PmenuSel ctermbg=136 ctermfg=16 cterm=bold
endfun

fun! s:ApplyColorscheme()
    colorscheme seoul256
    hi! link WildMenu PmenuSel
    hi erlangEdocTag cterm=bold ctermfg=14
    hi erlangFunHead cterm=bold ctermfg=4
    hi SPM1 ctermbg=1 ctermfg=7
    hi SPM2 ctermbg=2 ctermfg=7
    hi SPM3 ctermbg=3 ctermfg=7
    hi SPM4 ctermbg=4 ctermfg=7
    hi SPM5 ctermbg=5 ctermfg=7
    hi SPM6 ctermbg=6 ctermfg=7
    hi VertSplit cterm=none ctermbg=none ctermfg=16

    " disable weird standout mode
    hi ErrorMsg term=none
    hi Todo term=none
    hi SignColumn term=none
    hi FoldColumn term=none
    hi Folded term=none
    hi WildMenu term=none
    hi WarningMsg term=none
    hi Question term=none
    hi ErrorMsg term=none
endfun

if system('background') == "light\n"
    call g:LightRoom()
else
    call g:DarkRoom()
endif

fun! g:ApplySyntaxForDiffComments()
    syn match DiffCommentIgnore "^###.*" containedin=ALL
    syn match DiffComment "^#.*" containedin=ALL
    syn match DiffComment "^---.*" containedin=ALL
    syn match DiffComment "^+++.*" containedin=ALL
    syn match DiffComment "^@@ .*" containedin=ALL
    syn match DiffAdded "^+" containedin=ALL
    syn match DiffRemoved "^-" containedin=ALL
    syn match DiffContext "^ " containedin=ALL


    if &background == 'light'
        hi DiffCommentIgnore ctermfg=249 ctermbg=none
        hi DiffComment ctermfg=16 ctermbg=254
    else
        hi DiffCommentIgnore ctermfg=249 ctermbg=none
        hi DiffComment ctermfg=15 ctermbg=237
    endif

    hi DiffAdded ctermbg=192 ctermfg=123 cterm=bold
    hi DiffRemoved ctermbg=216 ctermfg=146 cterm=bold
    hi DiffContext ctermbg=253 ctermfg=253
endfun
