lua require("guevarez")

" -- Standard File Save
 let g:neoformat_try_node_exe = 1
autocmd BufWritePre *.js Neoformat
au BufWritePre,FileWritePre *.go :GoFmt

" -- Rust
syntax enable
filetype plugin indent on
let g:rustfmt_autosave = 1

tnoremap <Esc> <C-\><C-n>
set clipboard+=unnamedplus

" -- Colors and transparency
set termguicolors
highlight Normal guibg=none
highlight NonText guibg=none

" -- Auto update on file change
set autoread
au FocusGained * :checktime

