set nocompatible

if empty(glob('~/.vim/autoload/plug.vim'))
    silent !mkdir -p ~/.vim/autoload
    silent !curl -fLo ~/.vim/autoload/plug.vim
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

augroup run_after_plug_end
    au!

call plug#begin('~/.vim/bundle')

let mapleader="\<space>"

let g:vim_indent_cont = shiftwidth()

Plug 'dahu/SearchParty'
    au VimEnter * au! SearchPartySearching
    au BufEnter * let b:searching = 0
    au CursorHold * call SPAfterSearch()

    nmap <silent> <Leader><Leader> :let @/=''<CR><Plug>SearchPartyHighlightClear

Plug 'tmhedberg/matchit'

Plug 'scrooloose/nerdcommenter'
    nmap <Leader>l <Leader>cl

    au FileType pug setlocal comments=://-,:// commentstring=//-\ %s

Plug 'wojtekmach/vim-rename'

Plug 'vim-scripts/repeat.vim'

Plug 'seletskiy/vim-colorscheme-serenity'
    let g:colors_name = "serenity"


Plug 'vim-scripts/surround.vim'
    vmap ( S)i
    vmap ) S)%a

    vnoremap <leader>" S"i

    "imap <C-S> <C-\><C-O>:normal va"S)<CR>

    noremap <Leader>f dt(ds)

    "augroup surround_bash
    "    au!
    "    au FileType sh map <silent> <C-O> :normal viWS"<CR>
    "    au FileType sh map <silent> <C-]> :normal viWS)i$<CR>
    "augroup END

Plug 'seletskiy/nginx-vim-syntax'

Plug 'junegunn/fzf', {'do': './install --all'}
Plug 'junegunn/fzf.vim'
    let g:fzf_prefer_tmux = 0
    let g:fzf_layout = { 'down': '~40%' }

    func! _select_file()
        "call _snippets_stop()
        call fzf#run(fzf#wrap({
            \ 'source': 'prols',
            \ 'options': '--sort --no-exact --tiebreak=index --tac'
            \ }))
    endfunc!

    func! _select_buffer()
        "call _snippets_stop()
        call fzf#vim#buffers({'options': '--sort --no-exact'})
    endfunc!

    "nnoremap <C-G> :call _select_buffer()<CR>
    map <silent> <C-P> :call _select_file()<CR>

Plug 'rhysd/git-messenger.vim'

Plug 'nixprime/cpsm', {'do': 'PY3=OFF ./install.sh' }
    let g:grep_last_query = ""

    func! _grep(query)
        let g:grep_last_query = a:query

        let @/ = a:query
        call fzf#vim#ag(a:query, {'down': 10, 'options': '--delimiter : --nth 4..'})
    endfunc!

    func! _grep_word()
        let l:word = expand('<cword>')
        call _grep(l:word)
    endfunc!

    func! _grep_slash()
        let l:slash = strpart(@/, 2)
        call _grep(l:slash)
    endfunc!

    func! _grep_recover()
        call _grep(g:grep_last_query)
    endfunc!

    command! -nargs=* Grep call _grep(<q-args>)

    nnoremap <silent> <C-K> :Grep<CR>
    nnoremap <C-T> :Grep <C-R><C-W><CR>

Plug 'itchyny/lightline.vim'
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'enable': {
      \     'statusline': 1,
      \     'tabline': 0
      \ },
      \ 'component': {
      \   'filename': '%f'
      \ }
      \ }

"Plug 'seletskiy/vim-autosurround'

Plug 'SirVer/ultisnips'
    let g:UltiSnipsExpandTrigger = '<nul>'
    let g:UltiSnipsJumpForwardTrigger = '<C-F>'
    let g:UltiSnipsJumpBackwardTrigger = '<C-G>'

    let g:UltiSnipsSnippetDirectories = [
        \ $HOME.'/.vim/bundle/snippets',
        \ $HOME.'/.vim/UltiSnips'
    \ ]

    let g:UltiSnipsEnableSnipMate = 0
    let g:UltiSnipsEditSplit = "horizontal"
    let g:UltiSnipsUsePythonVersion = 2

    func! _snippets_get_filetype()
        let l:dot = strridx(&filetype, ".")
        if l:dot != -1
            return strpart(&filetype, 0, dot)
        endif

        return &filetype
    endfunc!

    let g:snippets_dotfiles = $HOME . "/.vim/UltiSnips/"
    let g:snippets_reconquest = $HOME . "/.vim/bundle/snippets/"

    func! _snippets_open_dotfiles()
        split
        execute "edit" g:snippets_dotfiles .
                    \ _snippets_get_filetype() . ".snippets"
    endfunc!

    func! _snippets_open_reconquest()
        split
        execute "edit" g:snippets_reconquest .
                    \ _snippets_get_filetype() .  ".snippets"
    endfunc!

    augroup ultisnips_pyflakes
        au!
        au BufEnter,BufWinEnter *.snippets let g:pymode_lint = 0
        au BufEnter,BufWinEnter *.py let g:pymode_lint = 1
    augroup end

    nnoremap <C-C><C-D> :call _snippets_open_dotfiles()<CR>
    nnoremap <C-C><C-S> :call _snippets_open_reconquest()<CR>

Plug 'fatih/vim-go', {'for': 'go'}
    let g:go_fmt_command = "goimports"
    let g:go_snippet_engine = "skip"
    let g:go_fmt_autosave = 0
    let g:go_fmt_fail_silently = 1
    let g:go_metalinter_command="gometalinter -D golint --cyclo-over 15"
    let g:go_highlight_functions = 1
    let g:go_highlight_methods = 1
    let g:go_template_autocreate = 0
    let g:go_def_mapping_enabled = 0
    let g:go_def_mode = 'godef'

    let g:go_list_type = "quickfix"

    func! _goto_prev_func()
        call search('^func ', 'b')
        nohlsearch
        normal zt
    endfunc!

    func! _goto_next_func()
        call search('^func ', '')
        nohlsearch
        normal zt
    endfunc!

    augroup vim_go_custom
        au!
        au FileType go nmap <buffer> <Leader>h :GoDoc<CR>
        "au FileType go nmap <silent><buffer> gd :GoDef<CR>
        au FileType go nmap <silent><buffer> gl :call go#def#Jump('vsplit', 0)<CR>
        au FileType go nmap <silent><buffer> gk :call go#def#Jump('split', 0)<CR>

        au FileType go nmap <silent><buffer> <C-Y> :w<CR>:call synta#go#build()<CR>
        au FileType go imap <silent><buffer> <C-Y> <ESC>:w<CR>:call synta#go#build()<CR>
    augroup end

Plug 'vim-ruby/vim-ruby'
Plug 'ruby-formatter/rufo-vim'

Plug 'michaeljsmith/vim-indent-object'

Plug 'xolox/vim-misc'

Plug 'cespare/vim-toml'

Plug 'seletskiy/vim-over80'
Plug 'markonm/traces.vim'

Plug 'wellle/targets.vim'

Plug 'maksimr/vim-jsbeautify'

Plug 'reconquest/vim-pythonx'

Plug 'reconquest/snippets'

Plug 'justinmk/vim-sneak'
    let g:sneak#streak = 1

    nmap S <Plug>Sneak_S
    vmap S <Plug>Sneak_S
    nmap s <Plug>Sneak_s
    vmap s <Plug>Sneak_s
    nmap f <Plug>Sneak_f
    vmap f <Plug>Sneak_f
    nmap F <Plug>Sneak_F
    vmap F <Plug>Sneak_F

augroup sneak_colorscheme  " Re-init on :colorscheme change at runtime. #108

Plug 'hynek/vim-python-pep8-indent'

Plug 'kovetskiy/vim-bash'

Plug 'junegunn/vim-easy-align'
    " Start interactive EasyAlign in visual mode (e.g. vipga)
    xmap ga <Plug>(EasyAlign)

    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
    nmap ga <Plug>(EasyAlign)

Plug 'deadcrew/deadfiles'

Plug 'kovetskiy/vim-ski'
    let g:skeletons_dir=$HOME . '/.vim/bundle/snippets/skeletons/'

Plug 'FooSoft/vim-argwrap'

Plug 'kovetskiy/synta'
   let g:synta_use_go_fast_build = 0

Plug 'kovetskiy/vim-hacks'

Plug 'tpope/vim-abolish'

Plug 'digitaltoad/vim-pug'

Plug 'kovetskiy/vim-autoresize'

Plug 'nathanielc/vim-tickscript'

Plug 'w0rp/ale'
    let g:ale_enabled = 0

    function! s:ale_gts_fixer(buffer) abort
        let l:options = ale#Var(a:buffer, 'typescript_gts_options')
        let l:executable = ale#Var(a:buffer, 'typescript_gts_executable')


        if !executable(l:executable)
            return 0
        endif

        return {
        \   'command': ale#Escape(l:executable)
        \       . ' ' . (empty(l:options) ? '' : ' ' . l:options)
        \       . ' %t',
        \   'read_temporary_file': 1,
        \}

    endfunction

    let g:ale_fixers = {
    \   'go': [function("synta#ale#goimports#Fix"), function("synta#ale#goinstall#Fix")],
    \   'ruby': [function('ale#fixers#rufo#Fix')],
    \   'scala': [function('ale#fixers#scalafmt#Fix')],
    \   'java': [function('ale#fixers#google_java_format#Fix')],
    \   'proto': [function('ale#fixers#clangformat#Fix')],
    \   'c': [function('ale#fixers#clangformat#Fix')],
    \   'cpp': [function('ale#fixers#clangformat#Fix')],
    \   'typescript': [function('s:ale_gts_fixer')],
    \   'vue': [function('ale#fixers#prettier#Fix')],
    \   'pug': [function('ale#fixers#prettier#Fix')],
    \   'scss': [function('ale#fixers#prettier#Fix')],
    \}
    let g:ale_linters = {
    \   'go': ['gobuild'],
    \   'typescript': ['npx gts check'],
    \}
    let g:ale_go_langserver_executable = 'gopls'
    let g:ale_fix_on_save = 1
    augroup ale_protobuf
        au!
        au BufEnter *.proto let g:ale_c_clangformat_options='-style=file -assume-filename=' . expand('%:t')
    augroup end

    augroup _java_codestyle
        au!
        au BufRead,BufNewFile *.java setlocal ts=2 sts=2 sw=2 expandtab
        au BufRead,BufNewFile *.java
            \ call ale#Set('java_google_java_format_executable',
            \ 'palantir-java-format')
        au BufRead,BufNewFile *.java
            \ call ale#Set('java_google_java_format_options',
            \ '--skip-removing-unused-imports --skip-sorting-imports')
        au BufRead,BufNewFile *.ts
            \ call ale#Set('typescript_gts_executable',
            \ 'npx')
        au BufRead,BufNewFile *.ts
            \ call ale#Set('typescript_gts_options',
            \ 'gts fix')

    augroup end

"Plug 'mg979/vim-visual-multi', {'branch': 'master'}
"    let g:VM_use_TextYankPost = 0
"    let g:VM_leader = "\\"
"    let g:VM_default_mappings = 0
"    let g:VM_no_meta_mappings = 1
"    "let g:VM_maps = {
"    "\ 'Select All': '<C-A>',
"    "\ }

"    fun! VM_before_auto()
"        call MacroBefore()
"    endfun

"    fun! VM_after_auto()
"        call MacroAfter()
"    endfun

"    function! MacroBefore(...)
"        unmap f
"        unmap F
"        unmap t
"        unmap T
"        unmap ,
"        unmap ;
"    endfunction!

"    function! MacroAfter(...)
"        map f <Plug>Sneak_f
"        map F <Plug>Sneak_F
"        map t <Plug>Sneak_t
"        map T <Plug>Sneak_T
"        map , <Plug>Sneak_,
"        map ; <Plug>Sneak_;
"    endfunction!

Plug 'pangloss/vim-javascript'

Plug 'pinkplus/vim-soy'

Plug 'jceb/vim-orgmode'

Plug 'tpope/vim-speeddating'

Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
    func! _expand_snippet()
        if pumvisible() && !empty(v:completed_item)
            return coc#_select_confirm()
        else
            let g:_expand_snippet = 1
            call UltiSnips#ExpandSnippet()
            let g:_expand_snippet = 0

            if g:ulti_expand_res == 0
                call coc#refresh()
                let col = col('.') - 1
                if !col || getline('.')[col - 1]  =~# '\s'
                    return "\<tab>"
                end
            else
                call coc#refresh()
                return ""
            end
        end

        return "\<c-n>"
    endfunc

    inoremap <silent> <Tab> <c-r>=_expand_snippet()<cr>
    xnoremap <silent> <Tab> <Esc>:call UltiSnips#SaveLastVisualSelection()<cr>gvs

    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    func! _coc_timer_hold()
        if exists('b:_coc_timer_moved') && b:_coc_timer_moved == 1
            call CocActionAsync('showSignatureHelp')
            let b:_coc_timer_moved = 0
        endif
    endfunc!

    func! _coc_timer_moved()
        let b:_coc_timer_moved = 1
    endfunc!

    autocmd CursorHold  * call _coc_timer_hold()
    autocmd CursorHoldI  * call _coc_timer_hold()
    autocmd CursorMoved * call _coc_timer_moved()
    autocmd CursorMovedI * call _coc_timer_moved()

"Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
"Plug 'josa42/coc-go', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-java', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-vetur', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-git', {'do': 'yarn install --frozen-lockfile'}
"Plug 'fannheyward/coc-xml', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-git', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-tslint-plugin', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-tabnine', {'do': 'yarn install --frozen-lockfile'}

Plug 'tpope/vim-dispatch'
    func! _setup_java()
        setlocal errorformat=[ERROR]\ %f:[%l\\,%v]\ %m
    endfunc!

    augroup _java_bindings
        au!
        au FileType java call _setup_java()
        au FileType java let b:dispatch = 'make'
        au FileType java nmap <silent><buffer> <C-M> :CocCommand java.action.organizeImports<CR>
        "au FileType java nmap <silent><buffer> gd :JavaDocSearch<CR>
        au FileType java nmap <silent><buffer> ; :cn<CR>
        au FileType java nmap <silent><buffer> <Leader>; :cN<CR>
    augroup end

"Plug 'eclim/eclim'
"    let g:EclimSignLevel = 'off'

Plug 'digitaltoad/vim-pug'
Plug 'cakebaker/scss-syntax.vim'

"Plug 'liuchengxu/vim-clap', { 'do': function('clap#helper#build_all') }

Plug 'terryma/vim-expand-region'

Plug 'Yggdroot/indentLine'
    let g:indentLine_char_list = [' ', '⠄1', '⡂', '⡇', '⡜', '⢕', '⡷', '⢷', '⣿']
    let g:indentLine_color_term = 237
    let g:indentLine_enabled = 0

augroup end

call plug#end()

au VimEnter * au! run_after_plug_end

au FileType go au! vim-go
au FileType go au! vim-go-buffer

call sneak#util#strlen('trigger autoload')
au! sneak_colorscheme

colorscheme serenity

filetype plugin on
filetype indent on

" Hack to ensure, that ~/.vim is looked first
set rtp-=~/.vim
set rtp^=~/.vim

set tags=./.tags;/

set clipboard=unnamedplus
set title
set encoding=utf-8
set printencoding=cp1251
set timeoutlen=3000
set wildmenu
set undofile
set undodir=$HOME/.vim/runtime/undo
set directory=$HOME/.vim/runtime/tmp
set backupdir=$HOME/.vim/runtime/backup
set ttyfast
set number
set relativenumber
set hlsearch
set incsearch
set history=500
set smartcase
set ignorecase
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
set cino=(s,m1,+0,L0
set comments-=mb:*
set lazyredraw
set nofoldenable
set noequalalways
set winminheight=0
set shortmess+=sAIc
if !has('nvim')
    set viminfofile=$HOME/.vim/viminfo
endif
set signcolumn=yes

set backup

set formatoptions=crq1j

set list
set lcs=trail:·,tab:\ \ " <- trailing space here
set fcs=vert:│

let html_no_rendering=1

" Ctrl+Backspace in cmd line
cmap <C-H> <C-W>

imap <C-T> <C-R>=strpart(search("[)}\"'`\\]>]", "c"), -1, 0)<CR><Right>

map <Leader>` :tabnew ~/.vimrc<CR>

noremap <Leader>v V`]

nmap <silent> <C-S> :w<CR>
nmap <silent> <C-Q> :q<CR>
imap <silent> <C-S> <C-\><C-O>:w<CR>
nmap <silent> <Leader>p "*p

map <Leader>3 :b #<CR>
map <Leader>c :cd %:h<CR>

map <silent> <Leader>l <Plug>NERDCommenterToggle
vnoremap <silent> <C-G> $%
nnoremap <silent> <C-G> :ArgWrap<CR>
inoremap <silent> <C-G> <C-\><C-O>:ArgWrap<CR>

nnoremap <C-H> <C-W>h
nnoremap <C-N> <C-W>j
nnoremap <C-E> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-_> <C-W>_
nnoremap <C-^> <C-W>20+

vnoremap $ g_

noremap > >>
noremap < <<

nnoremap Q qq
nnoremap ! :g//norm n@q<CR>
vnoremap ! :g//norm n@q<CR>
vmap <expr> @ feedkeys(':norm @' . nr2char(getchar()) . "\<CR>")

vmap <silent> > >gv
vmap <silent> < <gv

nnoremap j gj
nnoremap k gk

inoremap <F1> <ESC>
nnoremap <F1> <ESC>

cnoremap <C-A> <Home>
cnoremap <C-K> <End>

inoremap <expr> <C-O> pumvisible()
            \ ? (feedkeys("\<C-N>") ? '' : '')
            \ : (feedkeys("\<C-O>", 'n') ? '' : '')

nnoremap <C-H> :%s/\v
vnoremap <C-H> :s/\v

nmap <C-L> V<C-H>

augroup erlang_indent
    au!
    au FileType erlang set indentexpr=""
    au BufEnter *.erl,rebar.config,*.hrl set ai
augroup end

augroup dir_autocreate
    au!
    au BufWritePre * if !isdirectory(expand('%:h')) | call mkdir(expand('%:h'),'p') | endif
augroup end

if has('nvim')
    augroup terminal
        au TermOpen * setl nonu nornu signcolumn=no
    augroup end
endif

func! _syn_vue_extend_pug()
    unlet b:current_syntax
    syn include @vuePug syntax/pug.vim
    syn region  vuePugTemplate start=+<template lang="pug">+ keepend end=+</template>+me=s-1 contains=@vuePug,htmlScriptTag,@htmlPreproc
endfunc

func! _syn_vue_extend_scss()
    unlet b:current_syntax
    syn include @vueScss syntax/scss.vim
    syn region  vueScssTemplate start=+<style lang="scss">+ keepend end=+</style>+me=s-1 contains=@vueScss,htmlScriptTag,@htmlPreproc
endfunc

func! _syn_vue_extend_ts()
    unlet b:current_syntax
    syn include @vueTs syntax/typescript.vim
    syn region  vueTsTemplate start=+<script lang="ts">+ keepend end=+</script>+me=s-1 contains=@vueTs,htmlScriptTag,@htmlPreproc
endfunc

func! _syn_vue_extend()
    call _syn_vue_extend_pug()
    call _syn_vue_extend_scss()
    call _syn_vue_extend_ts()
endfunc

augroup ft
    au!
    au BufEnter *.test.sh set ft=test.sh
    au BufEnter * let g:argwrap_tail_comma = 0
    au BufEnter *.amber set ft=pug
    "au FileType *.chart setl ft=chart
    au BufRead,BufNewFile PKGBUILD set ft=sh.pkgbuild

    au FileType sh setl iskeyword+=-,:
    au FileType sql set ft=mysql
    au FileType snippets setl ft+=.python
    au FileType c,cpp setl noet
    au FileType yaml,json setl ts=2 sts=2 sw=2
    au FileType ruby setl et ts=2 sts=2 sw=2
    au FileType java setl et ts=2 sts=2 sw=2
    au FileType proto setl et ts=2 sts=2 sw=2
    au FileType pug,typescript,scss setl et ts=2 sts=2 sw=2
    "au FileType org set noshowmode noruler laststatus=0 noshowcmd nornu nonu
    "au FileType org au CursorHold * silent! update
    "au FileType org au CursorHoldI * silent! update
    "au FileType org setl foldenable

    au FileType go setl noexpandtab
    au FileType nnoremap <buffer> K <Plug>(go-doc-vertical)
    "au FileType go nmap <buffer> <Leader>r <Plug>(go-run)
    "au FileType go map <buffer> <Leader>t <Plug>(go-test)
    "au FileType go map <buffer> <Leader>b <CR>:call synta#go#build(1)<CR>
    au FileType go call InstallGoHandlers()
    au BufEnter *.go let g:argwrap_tail_comma = 1
    "au FileType go nnoremap <buffer> <C-T> :call synta#quickfix#next()<CR>
    "au FileType go nnoremap <buffer> <C-E><C-R> :call synta#quickfix#prev()<CR>
    "au FileType go nnoremap <buffer> <C-E><C-T> :call synta#quickfix#error()<CR>
    "au FileType go nnoremap <buffer> <C-Q><C-D> :normal! A,<CR>
    "au FileType go inoremap <buffer> <C-Q><C-D> <C-\><C-O>:normal! A,<CR>
    "au FileType go nnoremap <buffer> gd :GoDef<CR>
    au BufRead,BufNewFile *.slide setfiletype present
    au BufRead,BufNewFile *standup setfiletype standup
    au FileType vue call _syn_vue_extend()
    au FileType * let g:indentLine_enabled = 0
    au FileType pug let g:indentLine_enabled = 1
augroup end

augroup vimrc
    au!
    au BufWritePost */.vimrc source %
    au BufWritePost */.Xresources call system('systemctl --user restart xrdb')
    au BufWritePost */.i3.config.* call system('systemctl --user restart i3:config')

    au BufWritePost /*/.vim/*/pythonx/*.py exec printf('py module="%s".rsplit("pythonx/", 2)[-1].rstrip(".py").replace("/", "."); __import__(module); reload(sys.modules[module])',
                \ expand('%:p'))
augroup end

augroup quickfix
    au!
    au FileType qf set wrap
augroup end

"augroup rainbow
"    au!
"    au BufEnter * RainbowParenthesesActivate
"    au Syntax * RainbowParenthesesLoadRound
"    au Syntax * RainbowParenthesesLoadBraces
"augroup end

augroup winfixheight
    au!
    au BufwinEnter set winfixheight
augroup end

augroup backups
    au BufWritePre * let &bex = '.' . strftime("%y%m%d%H%M") . '.bak'
augroup end

func! _tags_sh()
    if &ft != "sh"
        return
    endif

    let tagfiles = tagfiles()
    if len(tagfiles) > 0
        let tagfile = tagfiles[0]
        silent execute "!tags-sh " . tagfile . " >/dev/null 2>&1 &"
    endif
endfunc!

augroup sh_src
    au!
    au FileType sh call _tags_sh()
augroup end

augroup titlestring
    au!
    au BufEnter * set titlestring=vim\ [%{expand(\"%:~:.:h\")}\ >\ %t%(\ %M%)]
augroup end

com! BufWipe silent! bufdo! bw | enew!

function! InstallGoHandlers()
    augroup go_fmt
        au!

        autocmd BufWritePre *.go if searchpos('^\v(const|var)?\s+usage\s+\=\s+`', 'nw') != [0, 0] |
                \ silent! exe '/^\v(const|var)?\s+usage\s+\=\s+`/+1,/^`$/s/\t/    /' |
            \ endif
    augroup end
endfunction

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

fun! g:ApplySyntaxForDiffComments()
    let extension = expand('%:e')

    exec 'set syntax='.extension

    if &background == 'light'
        hi DiffCommentIgnore ctermfg=249 ctermbg=none
        hi DiffComment ctermfg=16 ctermbg=254
        hi DiffInfo ctermfg=16 ctermbg=252
        hi DiffAdded ctermbg=122 ctermfg=none cterm=none
        hi DiffRemoved ctermbg=216 ctermfg=1 cterm=none
        hi DiffContext ctermbg=254 ctermfg=254
    else
        hi DiffCommentIgnore ctermfg=249 ctermbg=none
        hi DiffComment ctermbg=235 ctermfg=248
        hi DiffInfo ctermfg=255 ctermbg=237
        hi DiffAdded ctermfg=2 cterm=none
        hi DiffRemoved ctermfg=1 cterm=none
        hi DiffContext ctermbg=238 ctermfg=236
    endif

    set nolist
endfun

func! ConflictFind()
    call search("\=\=\=\=\=\=", "e")
endfunc

func! ConflictApplyBottom()
    execute search("<<<<<", "bn") . ",." . "d"
    execute search(">>>>>>", "n") . "d"
    call ConflictFind()
endfunc!

func! ConflictApplyTop()
    execute ".," . search(">>>>>>", "n") . "d"
    execute search("<<<<<", "bn") . "d"
    call ConflictFind()
endfunc!

func! DiffEnable()
    nmap <buffer> rr :call ConflictFind()<CR>
    nmap <buffer> rk :call ConflictApplyTop()<CR>
    nmap <buffer> rj :call ConflictApplyBottom()<CR>
endfunc!

augroup diff_mode
    au!
    au BufEnter * if search("<<<<<<", "cnw", 0, 500) > 0 | call DiffEnable() | endif
augroup end

command!
    \ Diff
    \ call DiffEnable()

func! _get_github_link()
    silent call system("github-link " . expand('%:p') . " " . line('.'))
endfunc!

nnoremap <Leader>g :call _get_github_link()<CR>

augroup undo
    au!
    au CursorHoldI * call feedkeys("\<C-G>u", "n")
augroup endo

func _sudo_tee()
    w !sudo tee % > /dev/null
    e!
endfunc

augroup no_readonly_warning
    au!
    au FileChangedRO * set noreadonly
        \ | nmap <silent> <C-S> :call _sudo_tee()<CR>
        \ | imap <silent> <C-S> <C-\><C-O>:call _sudo_tee()<CR>
augroup end

nmap / /\v

let s:_search_mappings_applied = 0

func! _search_mappings_apply()
    if s:_search_mappings_applied != 0
        return
    endif

    if v:event['cmdtype'] == '/' || getcmdline() =~ "^\\v('\\<,'\\>|\\%)?s\\W"
        cmap <C-W> \w+
        cmap <C-O> .*

        let s:_search_mappings_applied = 1
    endif
endfun

func! _search_mappings_clear()
    if s:_search_mappings_applied != 0
        cunmap <C-W>
        cunmap <C-O>

        let s:_search_mappings_applied = 0
    endif
endfun

if has('nvim')
    augroup search_mappings
        au!
        au CmdlineEnter,CmdlineChanged * call _search_mappings_apply()
        au CmdlineLeave * call _search_mappings_clear()
    augroup end
endif

func! _split_set_content()
    let l:dirname = expand('%:h')
    let l:ext = expand('%:e')
    return l:dirname . '/.' . l:ext
endfunc!

func! _split_move_cursor()
    let l:ext = expand('%:e')
    call setcmdpos(len(getcmdline()) - len(expand(l:ext)))
    return ""
endfunc!

nnoremap <Leader>w :e <C-R>=_split_set_content()<CR><C-R>=_split_move_cursor()<CR>
nnoremap <Leader>x :vsp <C-R>=_split_set_content()<CR><C-R>=_split_move_cursor()<CR>
nnoremap <Leader>t :sp <C-R>=_split_set_content()<CR><C-R>=_split_move_cursor()<CR>

nmap <leader>z :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

inoremap <expr> <DOWN>  pumvisible() ? "\<C-N>" : "\<DOWN>"
inoremap <expr> <UP>    pumvisible() ? "\<C-P>" : "\<UP>"

py import px
py for full_name, name in px.libs().items(): exec("import " + full_name)
