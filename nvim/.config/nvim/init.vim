" -- Rust
syntax enable
filetype plugin indent on
let g:rustfmt_autosave = 1

" -- Highlight Current Line
set cursorline
:highlight Cursorline cterm=bold ctermbg=black

" -- Standard File Save
autocmd BufWritePre *.js Neoformat
au BufWritePre,FileWritePre *.go :GoFmt

lua require("guevarez")
