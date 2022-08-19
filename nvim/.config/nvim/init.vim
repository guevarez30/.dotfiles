lua require("guevarez")

" -- Standard File Save
autocmd BufWritePre *.js Neoformat
au BufWritePre,FileWritePre *.go :GoFmt


" -- Rust
syntax enable
filetype plugin indent on
let g:rustfmt_autosave = 1

tnoremap <Esc> <C-\><C-n>
autocmd TermOpen * setlocal nonumber norelativenumber
