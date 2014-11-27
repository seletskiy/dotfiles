set nocompatible

set rtp+=~/.vim/bundle/vundle
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'Raimondi/delimitMate'
Bundle 'nevar/revim'
Bundle 'tpope/vim-fugitive'
Bundle 'Gundo'
Bundle 'dahu/SearchParty'
Bundle 'matchit.zip'
Bundle 'scrooloose/nerdcommenter'
Bundle 'kien/rainbow_parentheses.vim'
Bundle 'git@github.com:seletskiy/vim-refugi'
Bundle 'wojtekmach/vim-rename'
Bundle 'repeat.vim'
Bundle 'junegunn/seoul256.vim'
Bundle 'surround.vim'
Bundle 'git@github.com:seletskiy/nginx-vim-syntax'
Bundle 'PHP-correct-Indenting'
Bundle 'Shougo/unite.vim'
Bundle 'Shougo/vimproc'
Bundle 'yuku-t/unite-git'
Bundle 'bling/vim-airline'
Bundle 'SirVer/ultisnips'
Bundle 'epmatsw/ag.vim'
Bundle 'Valloric/YouCompleteMe'
Bundle 'lyokha/vim-xkbswitch'
Bundle 'kristijanhusak/vim-multiple-cursors'
Bundle 'fatih/vim-go'
Bundle 'kshenoy/vim-signature'
Bundle 'vim-ruby/vim-ruby'
Bundle 'michaeljsmith/vim-indent-object'
Bundle 'xolox/vim-misc'
Bundle 'xolox/vim-notes'
Bundle 'cespare/vim-toml'
Bundle 'osyo-manga/vim-over'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'inkarkat/argtextobj.vim'
Bundle 'SchwarzeSonne/ash.vim'

syntax on
filetype plugin on
filetype indent on

" Hack to ensure, that ~/.vim is looked first
set rtp-=~/.vim
set rtp^=~/.vim

source ~/.vim/bundle/vim-go/ftplugin/go/doc.vim

set encoding=utf-8
set printencoding=cp1251
set timeoutlen=200
set wildmenu
set undofile
set undodir=$HOME/.vim/tmp/
set directory=$HOME/.vim/tmp/
set ttyfast
"set autowrite
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

" autocomplete list numbers
" autoinsert comment Leader
" do not wrap line after oneletter word
set formatoptions=qrn1tol

set list
set lcs=eol:¶,trail:·,tab:\ \ 

let g:go_fmt_command = "goimports"
let g:go_snippet_engine = "skip"

let g:notes_directories = ['~/.notes']

let g:airline_powerline_fonts = 1
let g:airline_theme = 'lucius'
let g:airline#extensions#whitespace#symbol = '☼'

let g:syntastic_always_populate_loc_list = 1

let g:syntastic_mode_map = { 'mode': 'passive',
                           \ 'active_filetypes': ['ruby', 'php'],
                           \ 'passive_filetypes': [''] }

let g:SignatureMarkOrder = "\m"

let g:XkbSwitchLib = '/usr/lib/libxkbswitch.so'
let g:XkbSwitchEnabled = 1
let mapleader="\<space>"

let g:Powerline_symbols = 'fancy'
let g:ycm_key_list_select_completion = ['<C-N>', '<Down>']
let g:ycm_allow_changing_updatetime = 0
let g:ycm_confirm_extra_conf = 1

let g:surround_102 = "\1function: \1(\r)"
let html_no_rendering=1

let g:unite_split_rule = "botright"
let g:unite_source_history_yank_enable = 1
let g:unite_enable_start_insert = 1
let g:unite_source_history_yank_file = $HOME.'/.vim/yankring.txt'

let g:UltiSnipsSnippetDirectories = [$HOME.'/.vim/UltiSnips']
let g:UltiSnipsDisableSnipMate = 1

call unite#custom#source(
    \ 'file,file/new,buffer,file_rec,file_rec/async,git_cached,git_untracked',
    \ 'matchers', 'matcher_fuzzy')

call unite#custom#default_action(
    \ 'directory', 'cd')

call unite#filters#sorter_default#use(['sorter_selecta'])

let delimitMate_expand_cr = 1

function! s:unite_my_settings()
    imap <buffer> <C-R> <Plug>(unite_redraw)
    imap <silent><buffer><expr> <C-T> unite#do_action('split')
endfunction

" Ctrl+Backspace
cmap <C-H> <C-W>
cmap <Esc>d <S-Right><C-W>

imap <C-T> <C-R>=strpart(search("[)}\"'`\\]]", "c"), -1, 0)<CR><Right>

map <C-P> :Unite -hide-source-names git_cached git_untracked buffer<CR>
map <C-Y> :Unite -hide-source-names history/yank<CR>
map <C-U> :Unite -hide-source-names file_rec/async buffer<CR>
map <C-E><C-G> :Unite -hide-source-names grep:.<CR>
map <C-E><C-E> :Unite -hide-source-names directory:~/sources/<CR>

let g:unite_source_grep_max_candidates = 200

let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = '-i --line-numbers --nocolor --nogroup --hidden'
let g:unite_source_grep_recursive_opt = ''

map <Leader>` :UltiSnipsEdit<CR>G
vmap <Leader>` y:UltiSnipsEdit<CR>Go<CR>snippet HERE<CR>endsnippet<ESC>k]p?HERE<CR>zzciw
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

nnoremap <TAB> %

noremap > >>
noremap < <<
imap <silent> <S-TAB> <C-O><<

nnoremap Q qq

vmap <silent> > >gv
vmap <silent> < <gv

vmap <expr> @ feedkeys(':norm @' . nr2char(getchar()) . "\<CR>")

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

nmap <silent> <Leader><Leader> :let @/="" \| call feedkeys("\<Plug>SearchPartyHighlightClear")<CR>

map - <Plug>(easymotion-prefix)

nnoremap H :OverCommandLine %s/\v<CR>
vnoremap H :OverCommandLine s/\v<CR>

map L <Leader>*:OverCommandLine %s//<CR>

nnoremap / :call searchparty#mash#unmash()<CR>:call g:DisableCC()<CR>/\v
nnoremap ? :call searchparty#mash#unmash()<CR>:call g:DisableCC()<CR>?\v

inoremap <expr> <C-O> (pumvisible() ? feedkeys("\<C-N>") : feedkeys("\<C-O>", 'n')) ? '' : ''

map <C-E><C-A> :Unite ash_inbox<CR>
map <C-E><C-R> :UniteResume<CR>

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
    au FileType diff syn match DiffComment "^#.*"
    au FileType diff syn match DiffCommentIgnore "^###.*"
    au FileType diff call g:ApplySyntaxForDiffComments()
augroup end

augroup hilight_over_80
    au!
    au VimResized,VimEnter * call g:CheckCC()
    au CursorHold * call g:CheckCC()
augroup end

augroup dir_autocreate
    au!
    au BufWritePre * if !isdirectory(expand('%:h')) | call mkdir(expand('%:h'),'p') | endif
augroup end

augroup skeletons
    au!
    au BufNewFile *.php exec "normal I<?php\<ESC>2o"
    au BufNewFile *.py exec "normal I# coding=utf8\<CR>\<ESC>xxo"
    au BufNewFile *.go exec "normal Ipackage \<C-R>=len(systemlist('ls '.expand('%:p:h').'/')) > 0 ? expand('%:p:h:t') : 'main'\<CR>"
    au BufNewFile rebar.config,*.app.src exec "normal I%% vim: et ts=4 sw=4 ft=erlang\<CR>\<ESC>xx"
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
    au FileType nnoremap K <Plug>(go-doc-vertical)
    au FileType go nmap <Leader>r <Plug>(go-run)
    au FileType go map <Leader>t <Plug>(go-test)
    au FileType go map <Leader>b <Plug>(go-build)
    au BufRead,BufNewFile *.slide setfiletype present
augroup end

let s:prev_line = 0
augroup rnu_nu
    au!
    au CursorMoved * if &rnu && line('.') != s:prev_line | set nornu nu | endif
    au CursorHold  * if &nu | set rnu | let s:prev_line = line('.') | endif
augroup end

augroup vimrc
    au!
    au BufWritePost ~/.vimrc source % | AirlineRefresh
augroup end

augroup snippets
    au!
    au FileType snippets map <buffer> ZZ :w\|b#<CR>
augroup end

augroup quickfix
    au!
    au FileType qf call g:DisableCC()
    au FileType qf set wrap
augroup end

augroup rainbow
    au!
    au VimEnter * RainbowParenthesesActivate
    au Syntax * RainbowParenthesesLoadRound
    au Syntax * RainbowParenthesesLoadBraces
augroup end

augroup fix_signcolumn
    au!
    "au BufEnter * sign define dummy
    "au BufEnter * execute 'sign place 10000 line=1 name=dummy buffer=' . bufnr('')
augroup end

com! BufWipe tabo <bar> silent! %bw <bar> enew!

com! StartNoting call g:StartNoting()

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
    hi Cursor ctermbg=0
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
    hi Cursor ctermbg=15
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
    hi PmenuSel ctermbg=136 ctermfg=15

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

fun! g:StartNoting()
    set showtabline=0
    set laststatus=0
    Note reading
    au CursorHold * if !&ro | write | endif
endfun

fun! g:DisableCC()
    set cc=""
endfun

fun! g:CheckCC()
    if &filetype == 'qf'
        return
    endif
    if exists("b:mash_search_item")
        for m in getmatches()
            if m.id == b:mash_search_item
                call g:DisableCC()
                return
            endif
        endfor
    endif
    try
        if searchpos(@/, 'nc') == [line('.'), col('.')]
            call g:DisableCC()
            return
        endif
    catch E35
    endtry
    if &columns > 80
        let &cc=join(range(80, &columns), ',')
    endif
endfun

if system('background') == "light\n"
    call g:LightRoom()
else
    call g:DarkRoom()
endif

fun! g:ApplySyntaxForDiffComments()
    if &background == 'light'
        hi DiffCommentIgnore ctermfg=249 ctermbg=none
        hi DiffComment ctermfg=16 ctermbg=254
    else
        hi DiffCommentIgnore ctermfg=249 ctermbg=none
        hi DiffComment ctermfg=15 ctermbg=237
    endif
endfun
