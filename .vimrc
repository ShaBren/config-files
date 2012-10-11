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
set ofu=syntaxcomplete#Complete
set t_Co=256

filetype plugin on
filetype indent plugin on

colorscheme solarized

set undofile
set undoreload=10000
set undodir=/Users/shabren/.vimundo/

noremap H ^
noremap L g_
nnoremap <cr> :noh<CR><CR>:<backspace>
noremap <C-n> :tabn<cr>
noremap <C-p> :tabp<cr>
