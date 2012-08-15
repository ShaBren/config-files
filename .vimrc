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
set smartindent

set nocp
filetype plugin on
set ofu=syntaxcomplete#Complete

filetype indent plugin on

nnoremap <cr> :noh<CR><CR>:<backspace>
