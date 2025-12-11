require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {
      {
        'mode',
        cond = function()
          return vim.bo.filetype ~= 'fugitive'
        end,
      },
    },
    lualine_b = {
      {
        'branch',
        cond = function()
          return vim.bo.filetype ~= 'fugitive'
        end,
      },
    },
    lualine_c = {
      {
        'filename',
        cond = function()
          return vim.bo.filetype ~= 'fugitive'
        end,
      },
      {
        function()
          local dir = vim.fn.FugitiveWorkTree()
          local branch = vim.fn.FugitiveHead()
          if dir ~= '' then
            local repo_name = vim.fn.fnamemodify(dir, ':t')
            if branch ~= '' then
              return ' ' .. repo_name .. '   ' .. branch
            end
            return ' ' .. repo_name
          end
          return ''
        end,
        cond = function()
          return vim.bo.filetype == 'fugitive'
        end,
        color = { fg = '#f5a97f', gui = 'bold' },
      },
    },
    lualine_x = {
      {
        'encoding',
        cond = function()
          return vim.bo.filetype ~= 'fugitive'
        end,
      },
      {
        'filetype',
        cond = function()
          return vim.bo.filetype ~= 'fugitive'
        end,
      },
    },
    lualine_y = {
      {
        'progress',
        cond = function()
          return vim.bo.filetype ~= 'fugitive'
        end,
      },
    },
    lualine_z = {
      {
        'location',
        cond = function()
          return vim.bo.filetype ~= 'fugitive'
        end,
      },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
