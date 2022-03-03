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
" -- Nerdtree
#Plug 'preservim/nerdtree'
" -- Icons
Plug 'kyazdani42/nvim-web-devicons'
" -- Prettier
Plug 'sbdchd/neoformat'
call plug#end()

autocmd BufWritePre *.js Neoformat

"# " Start NERDTree. If a file is specified, move the cursor to its window.
"# autocmd StdinReadPre * let s:std_in=1
"# autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif
"# " Start NERDTree when Vim starts with a directory argument.
"# autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
"#     \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif
"# " Open the existing NERDTree on each new tab.
"# autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif
"# " Exit Vim if NERDTree is the only window remaining in the only tab.
"# autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
"# " Toggle Nerd Tree Window
"# " Disable new buffers being created in nerd tree window
"# autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" | b# | endif

" declare your color scheme
colorscheme dracula

" Use this for dark color schemes
set background=dark


lua require('users')

let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_winsize = 25






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
nnoremap <C-p> :Telescope find_files<Cr>
nnoremap <leader>wl  <C-w>l
nnoremap <leader>w <C-W>
