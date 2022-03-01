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
set encoding=UTF-8

" -- Plugins
call plug#begin('~/.config/nvim/plugged')
" Telescope requires plenary to function
Plug 'nvim-lua/plenary.nvim'
" The main Telescope plugin
Plug 'nvim-telescope/telescope.nvim'
" An optional plugin recommended by Telescope docs
Plug 'nvim-telescope/telescope-fzf-native.nvim', {'do': 'make' }
" -- Color Scheme
Plug 'dracula/vim', { 'as': 'dracula' }
" -- lsp
Plug 'neovim/nvim-lspconfig'
" -- Autocomplete
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'onsails/lspkind-nvim'
" -- Treesitter
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
" -- vim-fugitive
Plug 'tpope/vim-fugitive'
" -- Lightline
Plug 'itchyny/lightline.vim'
" -- Icons
Plug 'kyazdani42/nvim-web-devicons'
call plug#end()

" declare your color scheme
colorscheme dracula

" Use this for dark color schemes
set background=dark

lua require('users')

let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_winsize = 25
let g:netrw_liststyle = 3

nnoremap <C-p> :Telescope find_files<Cr>
" -- Prettier
let g:neoformat_try_node_exe = 1
