local ok, jdtls = pcall(require, "jdtls")
if not ok then
	vim.notify("nvim-jdtls not found", vim.log.levels.WARN)
	return
end

-- Find jdtls installation path (Mason installs it here)
local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

-- Check if jdtls is installed
if vim.fn.isdirectory(jdtls_path) == 0 then
	vim.notify("jdtls not installed. Run :MasonInstall jdtls", vim.log.levels.WARN)
	return
end

-- Find project root
local root_markers = { "gradlew", "mvnw", ".git", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)

-- Workspace directory for jdtls (stores project-specific data)
local project_name = vim.fn.fnamemodify(root_dir or vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

-- Determine OS for config selection
local os_config = "mac"
if vim.fn.has("linux") == 1 then
	os_config = "linux"
elseif vim.fn.has("win32") == 1 then
	os_config = "win"
end

-- Find the launcher jar
local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
if launcher_jar == "" then
	vim.notify("jdtls launcher jar not found", vim.log.levels.ERROR)
	return
end

local config = {
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens", "java.base/java.util=ALL-UNNAMED",
		"--add-opens", "java.base/java.lang=ALL-UNNAMED",
		"-jar", launcher_jar,
		"-configuration", jdtls_path .. "/config_" .. os_config,
		"-data", workspace_dir,
	},

	root_dir = root_dir,

	settings = {
		java = {
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
			completion = {
				favoriteStaticMembers = {
					"org.junit.Assert.*",
					"org.junit.Assume.*",
					"org.junit.jupiter.api.Assertions.*",
					"org.junit.jupiter.api.Assumptions.*",
					"org.junit.jupiter.api.DynamicContainer.*",
					"org.junit.jupiter.api.DynamicTest.*",
					"org.mockito.Mockito.*",
					"org.mockito.ArgumentMatchers.*",
				},
				filteredTypes = {
					"com.sun.*",
					"io.micrometer.shaded.*",
					"java.awt.*",
					"jdk.*",
					"sun.*",
				},
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
			codeGeneration = {
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
				hashCodeEquals = {
					useJava7Objects = true,
				},
				useBlocks = true,
			},
		},
	},

	init_options = {
		bundles = {},
	},

	on_attach = function(client, bufnr)
		-- Enable completion
		vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Keymaps
		local bufopts = { noremap = true, silent = true, buffer = bufnr }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
		vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, bufopts)

		-- Java-specific keymaps
		vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, { buffer = bufnr, desc = "Organize Imports" })
		vim.keymap.set("n", "<leader>jv", jdtls.extract_variable, { buffer = bufnr, desc = "Extract Variable" })
		vim.keymap.set("v", "<leader>jv", function() jdtls.extract_variable(true) end, { buffer = bufnr, desc = "Extract Variable" })
		vim.keymap.set("n", "<leader>jc", jdtls.extract_constant, { buffer = bufnr, desc = "Extract Constant" })
		vim.keymap.set("v", "<leader>jc", function() jdtls.extract_constant(true) end, { buffer = bufnr, desc = "Extract Constant" })
		vim.keymap.set("v", "<leader>jm", function() jdtls.extract_method(true) end, { buffer = bufnr, desc = "Extract Method" })
	end,

	capabilities = require("cmp_nvim_lsp").default_capabilities(),
}

jdtls.start_or_attach(config)
