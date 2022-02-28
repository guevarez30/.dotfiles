" --- General 
syntax on set exrc
set number
set relativenumber
set nohlsearch
set hidden
set noerrorbells
set expandtab
set smartindent
set nowrap
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
set noshowmode
set lcs+=space:·
set showmatch " Shows matching brackets
set ruler " Always shows location in file (line#)
set smarttab " Autotabs for certain code
set shiftwidth=2
set tabstop=2




" -- Plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" -- File Structure
Plug 'kyazdani42/nvim-web-devicons' 
Plug 'kyazdani42/nvim-tree.lua'
" -- Color Scheme
Plug 'martinsione/darkplus.nvim'
" -- Prettier
Plug 'sbdchd/neoformat'
call plug#end()

colorscheme darkplus

lua require('users.treesitter')

let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_winsize = 25
let g:netrw_liststyle = 3

nnoremap <leader>ff <cmd>Telescope find_files<cr>
" -- Prettier
let g:neoformat_try_node_exe = 1
autocmd BufWritePre *.js Neoformat 

