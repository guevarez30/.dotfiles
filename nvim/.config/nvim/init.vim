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
set clipboard=unnamed
set guifont=Consolas:h11
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
" -- Prettier
Plug 'sbdchd/neoformat'
call plug#end()

autocmd BufWritePre *.js Neoformat

" declare your color scheme
colorscheme dracula

" Use this for dark color schemes
set background=dark

lua require('users')

let mapleader = " " " map leader to Space
" -- Navigate Tab
nnoremap <leader>tl  :tabnext<CR>
nnoremap <leader>th  :tabprev<CR>
nnoremap <leader>td  :tabclose<CR>
nnoremap <leader>tn  :tabnew<CR>
nnoremap <leader>t1  1gt
nnoremap <leader>t2  2gt
nnoremap <leader>t3  3gt
nnoremap <leader>t4  4gt
nnoremap <leader>t5  5gt
nnoremap <leader>t6  6gt
nnoremap <leader>f   <S-^>
nnoremap <leader>e   <S-$>
nnoremap <C-x> :Explore <Cr>
nnoremap <C-p> :Telescope find_files<Cr>
