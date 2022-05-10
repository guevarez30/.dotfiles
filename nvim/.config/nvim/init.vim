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
Plug 'ThePrimeagen/harpoon'
" -- Find
Plug 'dyng/ctrlsf.vim'
" -- Rainbow brackets
Plug 'p00f/nvim-ts-rainbow'
" -- Rooter auto set directory of project
Plug 'airblade/vim-rooter'
" -- Startify Page
Plug 'mhinz/vim-startify'
" -- Go Formatter
Plug 'darrikonn/vim-gofmt', { 'do': ':GoUpdateBinaries' }
call plug#end()

" -- Rooter auto detect project root
let g:rooter_patterns = ['.git']
autocmd BufWritePre *.js Neoformat

" declare your color scheme
colorscheme dracula

lua require('users')
let mapleader = " " " map leader to Space

" -- Movement
nnoremap <leader>h   <S-^>
nnoremap <leader>l   <S-$>
nnoremap <leader>o o<Esc>
nnoremap <leader>O O<Esc>

nnoremap <C-p> :Telescope find_files<Cr>

" -- Ctrl SF word search
nmap     <C-F>f <Plug>CtrlSFPrompt
nnoremap <C-F>t :CtrlSFToggle<CR>
inoremap <C-F>t <Esc>:CtrlSFToggle<CR>

" -- Harpoon
nnoremap <leader>m  :lua require("harpoon.mark").add_file() <CR>
nnoremap <leader>ml :lua require("harpoon.ui").toggle_quick_menu() <CR>
nnoremap <leader>mn :lua require("harpoon.ui").nav_next() <CR>
nnoremap <leader>mp :lua require("harpoon.ui").nav_prev() <CR>

" -- Move entire line up or down
nnoremap <C-Up> <Up>ddp<Up>
nnoremap <C-Down> ddp

" -- Move Windows
nnoremap <leader>w <C-w>w

" -- Vexplore
nnoremap <leader>v :Vexplore<CR>

nnorema <leader>q :q<CR>

" -- Git
nnoremap <leader>gs :G<CR>

" -- Startify

let g:startify_lists = [
\ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
\ { 'type': 'commands',  'header': ['   Commands']       },
\ ]

let g:startify_bookmarks = [
  \ { 'b': '~/.bashrc' },
  \ { 'n': '~/.config/nvim/init.vim' },
  \ { 'l': '~/.localrc' },
  \ ]

let g:startify_commands = [
    \ {'p': ['Find Files', 'Telescope find_files']},
    \ {'x': ['Explore', 'Explore']},
    \ ]

let g:startify_custom_header = [
 \' _  _ ____ ____ _  _ _ _  _',
 \' |\ | |___ |  | |  | | |\/|',
 \' | \| |___ |__|  \/  | |  |',
 \]

"-- Go AutoFormatter
au BufWritePre,FileWritePre *.go :GoFmt
