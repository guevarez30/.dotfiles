require'nvim-treesitter.configs'.setup {
  ensure_installed = {"python", "bash", "javascript", "go", "http", "json", "rust", "vim", "glimmer"},

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  rainbow = {
    enable = true,
    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    colors = {
      "#8be9fd",
      "#ffb86c",
      "#ff79c6",
      "#bd93f9",
      "#ff5555",
      "#f1fa8c",
      "#f8f8f2"
    }, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  }
}
vim.g.rainbow_active = 1
