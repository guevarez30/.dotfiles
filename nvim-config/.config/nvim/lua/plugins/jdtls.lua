return {
	"mfussenegger/nvim-jdtls",
	ft = { "java" },
	config = function()
		local ok, jdtls = pcall(require, "jdtls")
		if not ok then
			vim.notify("nvim-jdtls not found", vim.log.levels.WARN)
			return
		end

		local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
		if vim.fn.isdirectory(jdtls_path) == 0 then
			vim.notify("jdtls not installed. Run :MasonInstall jdtls", vim.log.levels.WARN)
			return
		end

		local root_markers = { "gradlew", "mvnw", ".git", "pom.xml", "build.gradle" }
		local root_dir = require("jdtls.setup").find_root(root_markers)
		local project_name = vim.fn.fnamemodify(root_dir or vim.fn.getcwd(), ":p:h:t")
		local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

		local os_config = "mac"
		if vim.fn.has("linux") == 1 then
			os_config = "linux"
		elseif vim.fn.has("win32") == 1 then
			os_config = "win"
		end

		local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
		if launcher_jar == "" then
			vim.notify("jdtls launcher jar not found", vim.log.levels.ERROR)
			return
		end

		jdtls.start_or_attach({
			cmd = {
				"java",
				"-Declipse.application=org.eclipse.jdt.ls.core.id1",
				"-Dosgi.bundles.defaultStartLevel=4",
				"-Declipse.product=org.eclipse.jdt.ls.core.product",
				"-Dlog.protocol=true",
				"-Dlog.level=ALL",
				"-Xmx1g",
				"--add-modules=ALL-SYSTEM",
				"--add-opens",
				"java.base/java.util=ALL-UNNAMED",
				"--add-opens",
				"java.base/java.lang=ALL-UNNAMED",
				"-jar",
				launcher_jar,
				"-configuration",
				jdtls_path .. "/config_" .. os_config,
				"-data",
				workspace_dir,
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
			on_attach = function(_, bufnr)
				vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

				local bufopts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", bufopts, { desc = "Rename symbol" }))
				vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, bufopts)

				vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, { buffer = bufnr, desc = "Organize imports" })
				vim.keymap.set("n", "<leader>jv", jdtls.extract_variable, { buffer = bufnr, desc = "Extract variable" })
				vim.keymap.set("v", "<leader>jv", function()
					jdtls.extract_variable(true)
				end, { buffer = bufnr, desc = "Extract variable" })
				vim.keymap.set("n", "<leader>jc", jdtls.extract_constant, { buffer = bufnr, desc = "Extract constant" })
				vim.keymap.set("v", "<leader>jc", function()
					jdtls.extract_constant(true)
				end, { buffer = bufnr, desc = "Extract constant" })
				vim.keymap.set("v", "<leader>jm", function()
					jdtls.extract_method(true)
				end, { buffer = bufnr, desc = "Extract method" })
			end,
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
		})
	end,
}
