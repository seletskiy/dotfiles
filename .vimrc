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

Plug 'wojtekmach/vim-rename'

Plug 'vim-scripts/repeat.vim'

Plug 'reconquest/vim-colorscheme'
    let g:colors_name = "reconquest"

    au ColorScheme * hi MatchParen ctermfg=226 ctermbg=none cterm=bold
    au ColorScheme * hi Search cterm=bold ctermfg=16 ctermbg=226
    au ColorScheme * hi IncSearch cterm=none ctermfg=15 ctermbg=92
    au ColorScheme * hi Cursor cterm=bold ctermfg=16 ctermbg=226
    au ColorScheme * hi DiffChange ctermbg=162 ctermfg=15 cterm=bold
    au ColorScheme * hi Error ctermbg=1 ctermfg=16 cterm=bold


Plug 'vim-scripts/surround.vim'
    vmap ( S)i
    vmap ) S)%a

    vmap " S"i
    vnoremap g" "

    "imap <C-S> <C-\><C-O>:normal va"S)<CR>

    noremap <Leader>f dt(ds)

    "augroup surround_bash
    "    au!
    "    au FileType sh map <silent> <C-O> :normal viWS"<CR>
    "    au FileType sh map <silent> <C-]> :normal viWS)i$<CR>
    "augroup END

Plug 'seletskiy/nginx-vim-syntax'

Plug 'junegunn/fzf', {'do': './install --all'}
Plug 'kovetskiy/fzf.vim'
    let g:fzf_prefer_tmux = 1
    au FileType * let g:fzf#vim#default_layout  = {'bottom': '10%'}
    let $FZF_DEFAULT_COMMAND = 'prols'
    func! _ctrlp()
        exec 'FZF'
    endfunc!

Plug 'nixprime/cpsm', {'do': 'PY3=OFF ./install.sh' }
Plug 'ctrlpvim/ctrlp.vim'
    func! _ctrlp_buffer_add_augroup()
        augroup _ctrlp_buffer_bufenter
            au!
            au BufEnter * exe "wincmd" "_" |
                        \ call _ctrlp_buffer_remove_augroup()
        augroup end
    endfunc!

    func! _ctrlp_buffer_remove_augroup()
        augroup _ctrlp_buffer_bufenter
            au!
        augroup end
    endfunc!

    func! _ctrlp_buffer()
        CtrlPBuffer
        call _ctrlp_buffer_add_augroup()
    endfunc!

    "func! _ctrlp()
    "    CtrlP
    "endfunc!

    "nnoremap <C-B> :call _ctrlp_buffer()<CR>

    let g:ctrlp_working_path_mode='ra'
    let g:ctrlp_user_command = 'ctrlp-search %s'
    let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:50'
    let g:ctrlp_match_func = {'match': 'cpsm#CtrlPMatch'}

    "let g:ctrlp_max_depth = 10

    let g:ctrlp_clear_cache_on_exit = 1
    let g:ctrlp_use_caching = 0
    let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp.vim'

    hi! def link CtrlPMatch Search

    let g:ctrlp_map = '<nop>'
    map <silent> <C-P> :call _ctrlp()<CR>

    let g:grep_last_query = ""

    func! _grep(query)
        let g:grep_last_query = a:query

        let @/ = a:query
        call fzf#vim#ag(a:query, {'options': '--delimiter : --nth 4..'})
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

    nnoremap <C-E> :Grep<CR>
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
    let g:UltiSnipsExpandTrigger = '<Tab>'
    let g:UltiSnipsJumpForwardTrigger = '<C-J>'
    let g:UltiSnipsJumpBackwardTrigger = '<C-K>'

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

    "nnoremap <C-S><C-D> :call _snippets_open_dotfiles()<CR>
    "nnoremap <C-S><C-S> :call _snippets_open_reconquest()<CR>
    "vnoremap <C-S> y:UltiSnipsEdit<CR>Go<CR>snippet HERE<CR>endsnippet<ESC>k]p?HERE<CR>zzciw

    augroup ultisnips_pyflakes
        au!
        au BufEnter,BufWinEnter *.snippets let g:pymode_lint = 0
        au BufEnter,BufWinEnter *.py let g:pymode_lint = 1
    augroup end

"Plug 'Shougo/deoplete.nvim'
"Plug 'zchee/deoplete-jedi'
"Plug 'fishbullet/deoplete-ruby'
"Plug 'roxma/nvim-yarp'
"Plug 'roxma/vim-hug-neovim-rpc'
"Plug 'zchee/deoplete-go', { 'do': 'make'}
"   let g:deoplete#enable_at_startup = 1

"    func! _setup_deoplete()
"       call deoplete#custom#source(
"           \ '_', 'min_pattern_length', 1)

"        call deoplete#custom#source('_', 'matchers', ['matcher_full_fuzzy'])
"        call deoplete#custom#source('_', 'sorters', [])

"       " unlimited candidate length
"        call deoplete#custom#source('_', 'max_kind_width', 0)
"        call deoplete#custom#source('_', 'max_menu_width', 0)
"        call deoplete#custom#source('_', 'max_abbr_width', 0)
"   endfunc!

"   augroup _setup_deoplete
"       au!
"       au VimEnter * call _setup_deoplete()
"   augroup end

"Plug 'maralla/completor.vim'
"   let g:completor_gocode_binary = $HOME . '/go/bin/gocode'
"   let g:completor_disable_ultisnips = 1

Plug 'Valloric/YouCompleteMe'
    let g:ycm_key_list_select_completion = ['<C-N>', '<Down>']
    let g:ycm_allow_changing_updatetime = 0
    let g:ycm_confirm_extra_conf = 1
    let g:ycm_global_ycm_extra_conf = $HOME . '/.vim/.ycm_extra_conf.py'
    let g:ycm_collect_identifiers_from_comments_and_strings = 1
    let g:ycm_collect_identifiers_from_tags_files = 1
    let g:ycm_use_ultisnips_completer = 0
    let g:ycm_complete_in_comments = 1
    let g:ycm_show_diagnostics_ui = 0

Plug 'kovetskiy/vim-go', {'for': 'go'}
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

    "au operations FileType go nmap <buffer><silent> <C-Q> :call _goto_prev_func()<CR>
    "au operations FileType go nmap <buffer><silent> <C-A> :call _goto_next_func()<CR>

    augroup vim_go_custom
        au!
        au FileType go nmap <buffer> <Leader>h :GoDoc<CR>
        au FileType go let w:go_stack = 'fix that shit'
        au FileType go let w:go_stack_level = 'fix that shit'
        au FileType go nmap <silent><buffer> gd :GoDef<CR>
        au FileType go nmap <silent><buffer> gl :call go#def#Jump('vsplit')<CR>
        au FileType go nmap <silent><buffer> gk :call go#def#Jump('split')<CR>

        au FileType go nmap <silent><buffer> <Leader>, :w<CR>:call synta#go#build()<CR>
        au FileType go imap <silent><buffer> <Leader>, <ESC>:w<CR>:call synta#go#build()<CR>
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

    nmap gs <Plug>Sneak_S
    vmap gs <Plug>Sneak_S

    nmap f <Plug>Sneak_f
    vmap f <Plug>Sneak_f
    nmap F <Plug>Sneak_F
    vmap F <Plug>Sneak_F

    au ColorScheme * hi Sneak ctermfg=226

Plug 'seletskiy/vim-nunu'

Plug 'hynek/vim-python-pep8-indent'

Plug 'vim-utils/vim-man'

Plug 'kovetskiy/vim-bash'

Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
    vnoremap <C-T> :Tabularize /

Plug 'deadcrew/deadfiles'

Plug 'kovetskiy/vim-ski'
    let g:skeletons_dir=$HOME . '/.deadfiles/.vim/skeletons/'

Plug 'FooSoft/vim-argwrap'

Plug 'kovetskiy/synta'
   let g:synta_use_go_fast_build = 0

Plug 'kovetskiy/vim-hacks'

Plug 'tpope/vim-abolish'

Plug 'airblade/vim-gitgutter'
    let s:nbsp=" "
    let g:gitgutter_sign_removed='-'
    let g:gitgutter_sign_modified=s:nbsp . '±'
    let g:gitgutter_sign_modified_removed='-±'
    let g:gitgutter_sign_column_always=1
    let g:gitgutter_enabled = 0

    "au CursorHold * GitGutterEnable

Plug 'digitaltoad/vim-pug'

Plug 'kovetskiy/vim-autoresize'

Plug 'nathanielc/vim-tickscript'

Plug 'w0rp/ale'
    func! _ale_gotags()

    endfunc!
    let g:ale_enabled = 0

    let g:ale_fixers = {
    \   'go': [function("synta#ale#goimports#Fix"), function("synta#ale#goinstall#Fix")],
    \   'ruby': [function('ale#fixers#rufo#Fix')],
    \   'scala': [function('ale#fixers#scalafmt#Fix')],
    \   'java': [function('ale#fixers#google_java_format#Fix')],
    \}
    let g:ale_linters = {
    \   'go': ['gobuild'],
    \}
    let g:ale_fix_on_save = 1
    " au operations BufRead,BufNewFile *.go

Plug 'mg979/vim-visual-multi', {'branch': 'master'}
    let g:VM_use_TextYankPost = 0
    let g:VM_leader = "\\"
    let g:VM_default_mappings = 0
    let g:VM_no_meta_mappings = 1
    "let g:VM_maps = {
    "\ 'Select All': '<C-A>',
    "\ }

    fun! VM_before_auto()
        call MacroBefore()
    endfun

    fun! VM_after_auto()
        call MacroAfter()
    endfun

    function! MacroBefore(...)
        unmap f
        unmap F
        unmap t
        unmap T
        unmap ,
        unmap ;
    endfunction!

    function! MacroAfter(...)
        map f <Plug>Sneak_f
        map F <Plug>Sneak_F
        map t <Plug>Sneak_t
        map T <Plug>Sneak_T
        map , <Plug>Sneak_,
        map ; <Plug>Sneak_;
    endfunction!

Plug 'pangloss/vim-javascript'

Plug 'pinkplus/vim-soy'

Plug 'jceb/vim-orgmode'

Plug 'tpope/vim-speeddating'

Plug 'gabrielelana/vim-markdown'
    let g:markdown_enable_spell_checking = 0
    let g:markdown_enable_mappings = 0

augroup end

call plug#end()

"sign define GitGutterDummy text=.
"exec "sign place 9999 line=9999 name=GitGutterDummy buffer=" . bufnr('')

"au VimEnter * doautocmd User _VimrcRunAfterPlugEnd
au VimEnter * au! run_after_plug_end

syntax on

filetype plugin on
filetype indent on

" Hack to ensure, that ~/.vim is looked first
set rtp-=~/.vim
set rtp^=~/.vim

set tags=./.tags;/

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
set viminfofile=$HOME/.vim/viminfo

set backup

" autocomplete list numbers
" autoinsert comment Leader
" do not wrap line after oneletter word
set formatoptions=qrn1tol

set list
set lcs=trail:·,space:┈,tab:\┈\┈ " <- trailing space here
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

nnoremap <Leader><Leader>u :PlugUpdate<CR>
nnoremap <Leader><Leader>i :PlugInstall<CR>


map <silent> <Leader>l <Plug>NERDCommenterToggle
vnoremap <silent> @; $%
nnoremap <silent> @; :ArgWrap<CR>
inoremap <silent> @; <C-\><C-O>:ArgWrap<CR>

inoremap <C-J> <nop>
snoremap <C-J> <nop>

nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
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

inoremap jj <ESC>
nnoremap j gj
nnoremap k gk

inoremap <F1> <ESC>
nnoremap <F1> <ESC>

cnoremap <C-A> <Home>
cnoremap <C-E> <End>

noremap <expr> <Leader>s feedkeys(":sp " . expand('%:h') . "/")

inoremap <expr> <C-O> pumvisible()
            \ ? (feedkeys("\<C-N>") ? '' : '')
            \ : (feedkeys("\<C-O>", 'n') ? '' : '')

nnoremap <C-H> :<C-R>=StartVisualReplace('%s/\v')<CR>
vnoremap <C-H> :<C-R>=StartVisualReplace('s/\v')<CR>

func! StartVisualReplace(line)
    let b:visual_replace = 1

    cmap <C-A><C-W> \w+
    cmap <C-X><C-W> <><Left>

    return a:line
endfunc

func! StopVisualReplace()
    if get(b:, 'visual_replace', 0)
        cunmap <C-A><C-W>
        cunmap <C-X><C-W>
    endif

    let b:visual_replace = 0
endfunc

augroup visual_replace
    au!
    au CmdlineEnter * call StopVisualReplace()
augroup end

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
    au FileType yaml setl ts=2 sts=2 sw=2
    au FileType ruby setl et ts=2 sts=2 sw=2
    au FileType java setl et ts=2 sts=2 sw=2
    au FileType org set noshowmode noruler laststatus=0 noshowcmd nornu nonu
    au FileType org au CursorHold * silent! update
    au FileType org au CursorHoldI * silent! update
    au FileType org setl foldenable

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
    au CursorHoldI * call feedkeys("\<C-G>u")
augroup end
