-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd("packadd packer.nvim")

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Themes
  use 'folke/tokyonight.nvim'
  use 'Mofiqul/dracula.nvim'
  use 'joshdick/onedark.vim'
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
  use {
  	"windwp/nvim-autopairs",
      config = function() require("nvim-autopairs").setup {} end
  }

  -- Prettier
  use 'sbdchd/neoformat'
  -- Go Formatter
  use { 'darrikonn/vim-gofmt', run = ':GoUpdateBinaries' }
  
  -- VIM Vinegar
  use 'tpope/vim-vinegar'
  -- VIM surround
  use 'tpope/vim-surround'
  -- VIM comment
  use 'tpope/vim-commentary'

  -- telescope
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0', requires = { {'nvim-lua/plenary.nvim'} }
  }
  -- Rust
  use 'rust-lang/rust.vim'

  use 'norcalli/nvim-colorizer.lua'
  
  -- Test Suite
  use {
    "klen/nvim-test",
    config = function()
      require('nvim-test').setup()
    end
  }

  -- Git 
  use 'lewis6991/gitsigns.nvim'

  -- Lazy git
  use 'kdheepak/lazygit.nvim'

  -- Tmux Intergration
  use('christoomey/vim-tmux-navigator')

end)
