set nocompatible

set rtp+=~/.vim/bundle/vundle
call vundle#rc()

Bundle 'gmarik/vundle'
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
Bundle 'git@github.com:seletskiy/vim-colors-solarized'
Bundle 'surround.vim'
"Bundle 'tpope/vim-unimpaired'
"Bundle 'git@github.com:seletskiy/smarty.vim'
Bundle 'git@github.com:seletskiy/nginx-vim-syntax'
Bundle 'PHP-correct-Indenting'
"Bundle 'git@github.com:seletskiy/Command-T'
Bundle 'Shougo/unite.vim'
Bundle 'Shougo/vimproc'
Bundle 'yuku-t/unite-git'
Bundle 'bling/vim-airline'
Bundle 'SirVer/ultisnips'
Bundle 'epmatsw/ag.vim'
Bundle 'Valloric/YouCompleteMe'
"Bundle 'airblade/vim-gitgutter'
Bundle 'mhinz/vim-signify'
Bundle 'lyokha/vim-xkbswitch'
Bundle 'scrooloose/syntastic'

syntax on
filetype plugin on
filetype indent on

" Hack to ensure, that ~/.vim is looked first
set rtp-=~/.vim
set rtp^=~/.vim

set encoding=utf-8
set printencoding=cp1251
set timeoutlen=400
set wildmenu
set undofile
set undodir=$HOME/.vim/tmp/
set directory=$HOME/.vim/tmp/
set ttyfast
set autowrite
set relativenumber
"set hidden
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

" autocomplete list numbers
" autoinsert comment leader
" do not wrap line after oneletter word
set formatoptions=qrn1tol

set list
set lcs=eol:¶,trail:·,tab:\ \ 

let g:airline_solarized_reduced = 0
let g:airline_powerline_fonts = 1
let g:airline_theme = 'solarized'
let g:airline#extensions#whitespace#symbol = '☼'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '│'
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''
let g:airline#extensions#tabline#show_buffers = 0

call unite#custom#source('file,file/new,buffer,file_rec,git_cached,git_untracked',
    \ 'matchers', 'matcher_fuzzy')

function! s:unite_my_settings()
    imap <buffer> <C-R> <Plug>(unite_redraw)
endfunction

function! s:unite_rec_git_or_file()
    if fugitive#head() == ""
        :Unite -start-insert file_rec
    else
        :Unite -start-insert git_cached git_untracked
    endif
endfunction

let g:XkbSwitchLib = '/usr/lib/libxkbswitch.so'
let g:XkbSwitchEnabled = 1
let mapleader="\<space>"

let g:Powerline_symbols = 'fancy'
let g:ycm_key_list_select_completion = ['<C-N>', '<Down>']

let g:surround_102 = "\1function: \1(\r)"
let html_no_rendering=1

cmap w!! %!sudo tee > /dev/null %

imap <C-T> <C-O>:call search("[)}\"'`\\]]", "c")<CR><Right>

map <C-T> :call <SID>unite_rec_git_or_file()<CR>

noremap <leader>v V`]
noremap <leader>p "1p

nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

nnoremap ? ?\v
vnoremap ? ?\v
nnoremap / /\v
vnoremap / /\v

nnoremap <TAB> %
vnoremap <TAB> %

noremap > >>
noremap < <<
imap <silent> <S-TAB> <C-O><<
vmap <silent> <TAB> >gv
vmap <silent> <S-TAB> <gv
vmap <silent> > >gv
vmap <silent> < <gv

inoremap jj <ESC>
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

cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>

nmap <silent> <space><space> <Plug>SearchPartyHighlightClear

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
    au BufEnter * hi SPM1 ctermbg=1 ctermfg=7
    au BufEnter * hi SPM2 ctermbg=2 ctermfg=7
    au BufEnter * hi SPM3 ctermbg=3 ctermfg=7
    au BufEnter * hi SPM4 ctermbg=4 ctermfg=7
    au BufEnter * hi SPM5 ctermbg=5 ctermfg=7
    au BufEnter * hi SPM6 ctermbg=6 ctermfg=7
augroup end

augroup hilight_over_80
    au!
    au VimResized,VimEnter * set cc= | for i in range(80, &columns > 80 ? &columns : 80) | exec "set cc+=" . i | endfor
augroup end

augroup dir_autocreate
    au!
    au BufWritePre * if !isdirectory(expand('%:h')) | call mkdir(expand('%:h'),'p') | endif
augroup end

augroup skeletons
    au!
    au BufNewFile *.php exec "normal I<?php\<ESC>2o"
    au BufNewFile *.py exec "normal I# coding=utf8\<CR>\<ESC>xxo"
    au BufNewFile rebar.config,*.app.src exec "normal I%% vim: et ts=4 sw=4 ft=erlang\<CR>\<ESC>xx"
augroup end

augroup ft_customization
    au!
    au BufEnter php set noexpandtab
    au FileType sql set ft=mysql
    au FileType tex :e ++enc=cp1251
    au BufEnter /data/projects/*.conf set ft=nginx
    au BufEnter /data/projects/*.conf syn on
    au FileType erlang set comments=:%%%,:%%,:%
augroup end

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
    call s:ApplyColorscheme()
    hi underlined cterm=underline
    hi LineNr ctermfg=249 ctermbg=none
    hi SignColumn ctermfg=240 ctermbg=none
    hi Normal ctermbg=none
    hi TabLine ctermfg=1 ctermbg=7 cterm=none
    hi ColorColumn ctermbg=230
    hi SpecialKey term=bold cterm=bold ctermfg=1
    hi NonText ctermfg=7 cterm=none term=none

    let g:airline_solarized_bg='light'
endfun

fun! g:DarkRoom()
    set background=dark
    call s:ApplyColorscheme()
    hi underlined cterm=underline
    hi LineNr ctermfg=238 ctermbg=none
    hi SignColumn ctermfg=240 ctermbg=none
    hi Normal ctermbg=none
    hi ColorColumn ctermbg=235
    hi SpecialKey term=bold cterm=bold ctermfg=1
    hi NonText ctermfg=0 cterm=none term=none

    let g:airline_solarized_bg='dark'
endfun

fun! s:ApplyColorscheme()
    let g:solarized_termcolors = 16
    let g:solarized_contrast = 'high'
    colorscheme solarized
    hi! link WildMenu PmenuSel
    hi erlangEdocTag cterm=bold ctermfg=14
    hi erlangFunHead cterm=bold ctermfg=4
endfun

if system('background') == "light\n"
    call g:LightRoom()
else
    call g:DarkRoom()
endif
