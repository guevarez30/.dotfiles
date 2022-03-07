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
Plug 'tpope/vim-commentary'
" -- Lightline
Plug 'itchyny/lightline.vim'
" -- Icons
Plug 'kyazdani42/nvim-web-devicons'
" -- Prettier
Plug 'sbdchd/neoformat'
" -- VIM Vinegar
Plug 'tpope/vim-vinegar'
" -- Plug 'ap/vim-buftabline'
Plug 'ThePrimeagen/harpoon'
" -- Find
Plug 'dyng/ctrlsf.vim'
call plug#end()

autocmd BufWritePre *.js Neoformat

" declare your color scheme
colorscheme dracula

lua require('users')
let mapleader = " " " map leader to Space
" -- Navigate Buffer Tab
nnoremap <leader>bn :bnext <CR>
nnoremap <leader>bp :bprev <CR>
nnoremap <leader>bd :bd <CR>
nnoremap <leader>bl :buffers <CR>
" -- Horizontal Movement
nnoremap <leader>f   <S-^>
nnoremap <leader>e   <S-$>
nnoremap <C-p> :Telescope find_files<Cr>
" -- Ctrl SF word search
nmap     <C-F>f <Plug>CtrlSFPrompt
nnoremap <C-F>t :CtrlSFToggle<CR>
inoremap <C-F>t <Esc>:CtrlSFToggle<CR>
" -- Harpoon
nnoremap <leader>m  :lua require("harpoon.mark").add_file() <CR>
nnoremap <leader>ml :lua require("harpoon.ui").toggle_quick_menu() <CR>
nnoremap <leader>m1 :lua require("harpoon.ui").nav_file(1) <CR>
nnoremap <leader>m2 :lua require("harpoon.ui").nav_file(2) <CR>
nnoremap <leader>m3 :lua require("harpoon.ui").nav_file(3) <CR>
nnoremap <leader>m4 :lua require("harpoon.ui").nav_file(4) <CR>
nnoremap <leader>mn :lua require("harpoon.ui").nav_next() <CR>
nnoremap <leader>mp :lua require("harpoon.ui").nav_prev() <CR>

nnoremap <C-Up> <Up>ddp<Up>
nnoremap <C-Down> ddp
