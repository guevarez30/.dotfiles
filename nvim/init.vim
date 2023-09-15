lua require("guevarez")

" -- Standard File Save
au BufWritePre,FileWritePre *.go :GoFmt
autocmd BufWritePre,FileWritePre *.jsx,*.js EslintFixAll

autocmd BufWritePre,FileWritePre *.ts Neoformat tsfmt

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

" -- Bookmarks
let g:bookmark_save_per_working_dir = 1
let g:bookmark_auto_save = 1

" -- Auto update on file change
set autoread
au FocusGained * :checktime
