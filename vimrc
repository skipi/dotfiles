set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/
set t_Co=256

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-haml'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-obsession'
Plugin 'altercation/vim-colors-solarized'
Plugin 'vim-scripts/tComment'
Plugin 'vim-ruby/vim-ruby'
" Plugin 'ecomba/vim-ruby-refactoring'
Plugin 'slim-template/vim-slim'
Plugin 'Shougo/unite.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'ervandew/supertab'
Plugin 'scrooloose/syntastic'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'kchmck/vim-coffee-script'
Plugin 'Shougo/vimproc.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'scrooloose/nerdtree'
Plugin 'AndrewRadev/inline_edit.vim'
Plugin 'chrisbra/csv.vim'
Plugin 'regedarek/ZoomWin'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-unimpaired'
Plugin 'mattn/gist-vim'
Plugin 'mattn/webapi-vim'
Plugin 'tpope/vim-fireplace'
Plugin 'guns/vim-clojure-static'
Plugin 'tpope/vim-classpath'
Plugin 'tpope/vim-leiningen'
Plugin 'majutsushi/tagbar'
" Plugin 'craigemery/vim-autotag'
Plugin 'mnpk/vim-jira-complete'
" Plugin 'gorodinskiy/vim-coloresque'
Plugin 'thoughtbot/vim-rspec'
Plugin 'jgdavey/tslime.vim'
Plugin 'benmills/vimux'
Plugin 'jgdavey/vim-turbux'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
Plugin 'tpope/vim-rvm'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
" Common settings
syntax enable
set backspace=2
filetype indent on
set autoindent
set number
set nobackup
set tabstop=2
set shiftwidth=2
set expandtab
set nowrap
set hlsearch
set incsearch
set ignorecase
set smartcase
set gdefault
set notimeout
set timeout
set ttimeoutlen=10
set cursorline
" Remap leader to ,
let mapleader = ","
" Remap tabs keys
" tab map doesn't work in most terminals - should work fine in gvim
nnoremap <C-S-tab> :tabprevious<CR>
nnoremap <C-tab>   :tabnext<CR>
nnoremap <C-t>     :tabnew<CR>
inoremap <C-S-tab> <Esc>:tabprevious<CR>i
inoremap <C-tab>   <Esc>:tabnext<CR>i
inoremap <C-t>     <Esc>:tabnew<CR>
" Remap moving lines
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv
nmap <F8> :TagbarToggle<CR>
" Unite vim remap
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#custom#source('file,file/new,buffer,file_rec,line', 'matchers', 'matcher_fuzzy')
" nnoremap <C-k> :<C-u>Unite -buffer-name=search -start-insert line<cr>
"

" vim-rspec maps
nnoremap <Leader>t :call RunCurrentSpecFile()<CR>
nnoremap <Leader>s :call RunNearestSpec()<CR>
nnoremap <Leader>l :call RunLastSpec()<CR>


" turbux
let g:turbux_command_rspec = 'bin/rspec'

" vimux
let g:VimuxOrientation = "v"

" CtrlP extensions
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPLastMode'
let g:ctrlp_extensions = ['buffertag', 'tag', 'line', 'dir']

" Indentation
set ts=2 sw=2 et
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1
autocmd VimEnter * IndentGuidesEnable

" Shift + CTRL + arrows mods
if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

" Plugins


call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#custom#source('file_rec/async','sorters','sorter_rank')

set laststatus=2
set mouse=a
set noshowmode
set wildmenu
set wildmode=list:longest,list:full
set wildignore=.git,*.swp,*/tmp/*
let g:solarized_termtrans=1
augroup FastEscape
  autocmd!
  au InsertEnter * set timeoutlen=0
  au InsertLeave * set timeoutlen=1000
augroup END
colorscheme solarized
set background=dark

let g:jiracomplete_url = $JIRA_URL
let g:jiracomplete_username = $JIRA_USER

set completefunc=syntaxcomplete#Complete
autocmd FileType ruby,eruby setl omnifunc=rubycomplete#Complete 
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete 
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_load_gemfile = 1
autocmd FileType ruby,eruby let g:rubycomplete_use_bundler = 1

au BufRead,BufNewFile *.skim setfiletype slim

