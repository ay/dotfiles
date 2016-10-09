" Alex Yakoubian's .vimrc

set encoding=utf-8                 " Represent characters in UTF-8
set nocompatible                   " Not compatible with legacy vi

let mapleader=","                  " Make , our <Leader>

" Display
set number                         " Show line numbers
set ruler                          " Show current row and column at bottom right
set title                          " Set terminal title
set laststatus=2                   " Always show the status line
set showcmd                        " Show (partial) command in last line of screen
set showmode                       " Show current mode at bottom of screen
set showmatch                      " Briefly jump to matching bracket
set cursorline                     " Highlight current line
set scrolloff=8                    " At least 8 lines above and below cursor
set colorcolumn=80                 " Draw line at 80 columns
set nowrap                         " Don't wrap lines
set list                           " Show trailing whitespace and tabs
set listchars=trail:.,tab:>.       " Show . and >. for trailing whitespace and tabs

" Backups and swap files
set noswapfile                     " Don't keep swap files
set nobackup                       " Don't keep backups after close
set nowritebackup                  " Don't keep backups while working
set directory=~/.vim/swap          " Store swap files in ~/.vim/swap
set backupdir=~/.vim/backup        " Store backups in ~/.vim/backup
set backupcopy=yes                 " Keep attributes of original file
set backupskip=/tmp/*,/private/tmp/*

" Autocompletion
set wildmenu                       " Operate command-line completion in enhanced mode
set wildmode=list:longest          " List all matches and complete longest common
set wildignore+=.git/,.hg/,.svn/   " Ignore source control directories
set wildignore+=*.pyc              " Ignore Python compiled files

" Misc
set history=50                     " Keep some history
set visualbell                     " Flash the screen instead of sounding
set noerrorbells                   " Be quiet
set hidden                         " Hide current buffer instead of closing it
set backspace=indent,eol,start     " Allow backspacing over everything in insert mode
set autoread                       " Reload file if changed outside of Vim
set nofoldenable                   " No folding
set splitbelow                     " Open new horizontal split pane on the bottom
set splitright                     " Open new vertical split pane to the right

" Indentation
set autoindent                     " Copy indent from current line onto new line
set smartindent                    " Try not to autoindent when it doesn't make sense
set softtabstop=2                  " Insert 2 spaces instead of an actual <Tab>
set shiftwidth=2                   " Use 2 spaces for autoindent
set tabstop=4                      " Show <Tab> as 4 spaces
set expandtab                      " Use appropriate number of spaces to insert <Tab>
set nosmarttab                     " Insert spaces according to softtabstop
set shiftround                     " Indent by multiples of shiftwidth

" Search
set nohlsearch                     " Don't keep highlighting all matches after search
set ignorecase                     " Ignore case while searching
set incsearch                      " Highlight matches as you type
set smartcase                      " Override ignorecase if search contains uppercase

" Initialize Vundle
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" Language plugins
Plugin 'fatih/vim-go'
Plugin 'elzr/vim-json'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'tpope/vim-markdown'

" Other plugins
Plugin 'airblade/vim-gitgutter'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-fugitive'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-rails'
Plugin 'kien/ctrlp.vim'
Plugin 'Lokaltog/vim-easymotion'

call vundle#end()
filetype plugin indent on

" Colors
set t_Co=256                       " 256 colors
syntax enable                      " Enable syntax highlighting
set background=dark                " Set a dark background
silent! colorscheme solarized      " Use solarized color scheme

" Quickly find and remove trailing whitespace with ,s
function! StripWhitespace ()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
nmap <Leader>s :call StripWhitespace ()<CR>

" Delete current buffer with ,d
nmap <Leader>d :bd<CR>

" Easily navigate to next buffer with ,n
nmap <Leader>n :bnext<CR>

" Go to previously open buffer with ,e
nmap <Leader>e :b#<CR>

" CtrlP shortcuts
nmap <Leader>t :CtrlP<CR>
nmap <Leader>b :CtrlPBuffer<CR>

" :w!! to write as root
cmap w!! % !sudo tee > /dev/null %

" Use powerline fonts (must be installed)
let g:airline_powerline_fonts = 1

" Fixes side column background color for gitgutter
highlight clear SignColumn
