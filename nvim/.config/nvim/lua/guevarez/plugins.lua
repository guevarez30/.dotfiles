-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd("packadd packer.nvim")

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Themes
  -- use 'folke/tokyonight.nvim'
  -- use 'Mofiqul/dracula.nvim'
  use 'Yazeed1s/minimal.nvim'
  use "EdenEast/nightfox.nvim" 
  use({
      'rose-pine/neovim',
      as = 'rose-pine',
  })


  -- Harpoon
  use 'ThePrimeagen/harpoon'

  -- Lua line
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- LSP 
  use 'neovim/nvim-lspconfig'
  -- Tree sitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use 'nvim-treesitter/nvim-treesitter-context'
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
  -- VIM surround
  use 'tpope/vim-surround'
  use 'tpope/vim-fugitive'

  -- Go Formatter
  use { 'darrikonn/vim-gofmt', run = ':GoUpdateBinaries' }
  -- telescope
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0', requires = { {'nvim-lua/plenary.nvim'} }
  }
  -- Rust
  use 'rust-lang/rust.vim'
  
  -- Test Suite
  use {
    "klen/nvim-test",
    config = function()
      require('nvim-test').setup()
    end
  }

  use {
    'numToStr/Comment.nvim',
     config = function()
       require('Comment').setup()
     end
  }

  -- Tmux Intergration
  use('christoomey/vim-tmux-navigator')
 
end)
