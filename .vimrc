filetype off
set nocp
execute pathogen#infect('~/config-files/.vim/bundle//{}')

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'Valloric/YouCompleteMe'
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-fugitive'

filetype plugin on

let g:pydiction_location = '/Users/shabren/.vim/bundle/pydiction/complete_dict'
syntax enable

set tabstop=4
set number
set laststatus=2 
set statusline=%F%m%r%h%w\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L] 
set ignorecase 
set paste 
set background=dark
set hlsearch
set incsearch
set modeline
set autoindent
set smartindent
set nocp
set history=1000
set t_Co=256
set shiftwidth=4

filetype indent plugin on

set ofu=syntaxcomplete#Complete

let g:jellybeans_use_lowcolor_black = 0

"colorscheme solarized
"colorscheme Monokai
"colorscheme jellybeans
colorscheme vimbrant


set undofile
set undoreload=10000
set undodir=/Users/shabren/.vimundo/

noremap H ^
noremap L g_
nnoremap <cr> :noh<CR><CR>:<backspace>
noremap <C-n> :tabn<cr>
noremap <C-p> :tabp<cr>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

