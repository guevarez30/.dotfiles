return {
	"Mofiqul/dracula.nvim",
	name = "dracula",
	priority = 1000,
	config = function()
		require("dracula").setup({
			transparent_bg = false,
			overrides = function(colors)
				local function blend(fg, bg, alpha)
					local function hex_to_rgb(hex)
						hex = hex:gsub("#", "")
						return tonumber(hex:sub(1, 2), 16),
							tonumber(hex:sub(3, 4), 16),
							tonumber(hex:sub(5, 6), 16)
					end

					local fr, fg_, fb = hex_to_rgb(fg)
					local br, bg_, bb = hex_to_rgb(bg)

					return string.format(
						"#%02x%02x%02x",
						math.floor(fr * alpha + br * (1 - alpha)),
						math.floor(fg_ * alpha + bg_ * (1 - alpha)),
						math.floor(fb * alpha + bb * (1 - alpha))
					)
				end

				return {
					DiffAdd = { bg = blend(colors.green, colors.bg, 0.18) },
					DiffChange = { bg = blend(colors.purple, colors.bg, 0.16) },
					DiffDelete = { bg = blend(colors.red, colors.bg, 0.18) },
					DiffText = { bg = blend(colors.orange, colors.bg, 0.24) },
				}
			end,
		})
		vim.cmd.colorscheme("dracula")
	end,
}
