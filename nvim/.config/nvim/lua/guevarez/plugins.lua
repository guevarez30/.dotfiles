-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- You can alias plugin names
  use {'dracula/vim', as = 'dracula'}

  -- vim-fugitive
  use 'tpope/vim-fugitive'
  use 'tpope/vim-commentary'

  -- Harpoon
  use 'ThePrimeagen/harpoon'

  -- Lightline
  use 'itchyny/lightline.vim'

  -- LSP 
  use 'neovim/nvim-lspconfig'

  -- Tree sitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  -- CMP
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
  use 'onsails/lspkind-nvim'

  -- Prettier
  use 'sbdchd/neoformat'

  -- VIM Vinegar
  use 'tpope/vim-vinegar'

  -- Find
  use 'dyng/ctrlsf.vim'

  -- Go Formatter
  use { 'darrikonn/vim-gofmt', run = ':GoUpdateBinaries' }

  -- telescope
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0', requires = { {'nvim-lua/plenary.nvim'} }
  }

end)