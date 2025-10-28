-- Better Looking Signs
vim.cmd[[highlight SignifySignAdd    ctermfg=green  guifg=#A6E3A1 cterm=NONE gui=NONE]]
vim.cmd [[highlight SignifySignDelete ctermfg=red    guifg=#F38BA8 cterm=NONE gui=NONE]]
vim.cmd [[highlight SignifySignChange ctermfg=yellow guifg=#F9E2AF cterm=NONE gui=NONE]]

vim.g['signify_sign_show_count']  = 0 
vim.g['signify_sign_add']  = '󱓻' 
vim.g['signify_sign_change']  = '󱓻'
vim.g['signify_sign_delete']  = '󱓻'
