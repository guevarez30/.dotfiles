-- Better Looking Signs
vim.cmd[[highlight SignifySignAdd    ctermfg=green  guifg=#00ff00 cterm=NONE gui=NONE]]
vim.cmd [[highlight SignifySignDelete ctermfg=red    guifg=#ff0000 cterm=NONE gui=NONE]]
vim.cmd [[highlight SignifySignChange ctermfg=yellow guifg=#ffff00 cterm=NONE gui=NONE]]

vim.g['signify_sign_show_count']  = 0 
vim.g['signify_sign_add']  = '' 
vim.g['signify_sign_change']  = ''
vim.g['signify_sign_delete']  = ''

