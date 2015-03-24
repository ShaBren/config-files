filetype off
set nocp
"execute pathogen#infect('~/config-files/.vim/bundle//{}')

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Plugin 'gmarik/vundle'
Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-fugitive'
Plugin 'Shougo/unite.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'ardagnir/conque-term'
Plugin 'bling/vim-airline'
Plugin 'edkolev/promptline.vim'
Plugin 'tpope/vim-eunuch'
Plugin 'vim-scripts/vimwiki'
Plugin 'flazz/vim-colorschemes'

filetype plugin on

let g:pydiction_location = '/Users/shabren/.vim/bundle/pydiction/complete_dict'
syntax enable

set number
set laststatus=2 
"set statusline=%F%m%r%h%w\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L] 
set ignorecase 
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
set showcmd
set showmatch
set ttyfast
set lazyredraw
set scrolloff=5
set sidescrolloff=5
set autochdir
set splitbelow
set splitright
set hidden
set backspace=2

filetype indent plugin on

set ofu=syntaxcomplete#Complete

let g:jellybeans_use_lowcolor_black = 0

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

let g:plantuml_executable_script = "puml"
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

let mapleader = " "

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
noremap <leader>l :bn<cr>
noremap <leader>h :bp<cr>
"noremap <C-p> :bp<cr>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
map <C-e> :NERDTreeToggle<CR>

au BufRead *.txt setlocal spell

autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

command Rs %! astyle --indent=force-tab -j -k3 -W1 -w -Y -f -D -H -U -A1 -O

set tabstop=4
autocmd Filetype python setlocal noexpandtab tabstop=4 shiftwidth=4
