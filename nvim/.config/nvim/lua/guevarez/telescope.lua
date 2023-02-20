local telescope = require("telescope")
telescope.setup{  
  defaults = { 
	  previewer = true,
	  file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    file_ignore_patterns = { 
      "node_modules", "storage" 
    }
  },
}
