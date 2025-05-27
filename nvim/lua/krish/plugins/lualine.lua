return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		-- local theme = "gruvbox-material" -- Change to desired theme
		-- local theme = "catp" -- Change to desired theme
		local theme = "rose-pine" -- Change to desired theme
		local colors
		local my_lualine_theme

		local function get_hl_color(hl, attr)
			local ok, result = pcall(vim.api.nvim_get_hl_by_name, hl, true)
			if ok and result[attr] then
				return string.format("#%06x", result[attr])
			end
			return "NONE"
		end

		if theme == "gruvbox-material" then
			colors = {
				bg = get_hl_color("Normal", "background"),
				fg = get_hl_color("Normal", "foreground"),
				yellow = get_hl_color("WarningMsg", "foreground"),
				cyan = get_hl_color("Special", "foreground"),
				darkblue = get_hl_color("Identifier", "foreground"),
				green = get_hl_color("String", "foreground"),
				orange = get_hl_color("Constant", "foreground"),
				violet = get_hl_color("Statement", "foreground"),
				magenta = get_hl_color("PreProc", "foreground"),
				blue = get_hl_color("Function", "foreground"),
				red = get_hl_color("Error", "foreground"),
			}

			my_lualine_theme = {
				normal = {
					a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				insert = {
					a = { bg = colors.green, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				visual = {
					a = { bg = colors.magenta, fg = colors.bg, gui = "bold,italic" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				command = {
					a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				replace = {
					a = { bg = colors.red, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				inactive = {
					a = { bg = colors.bg, fg = colors.fg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
			}
		elseif theme == "catp" then
			colors = require("catppuccin.palettes").get_palette("mocha")
			my_lualine_theme = {
				normal = {
					a = { bg = colors.blue, fg = "#000000", gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				insert = {
					a = { bg = colors.green, fg = "#000000", gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				visual = {
					a = { bg = colors.mauve, fg = "#000000", gui = "bold,italic" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				command = {
					a = { bg = colors.yellow, fg = "#000000", gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				replace = {
					a = { bg = colors.red, fg = "#000000", gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				inactive = {
					a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
					b = { bg = colors.inactive_bg, fg = colors.semilightgray },
					c = { bg = colors.inactive_bg, fg = colors.semilightgray },
				},
			}
		elseif theme == "rose-pine" then
			colors = require("rose-pine.palette")
		elseif theme == "kanagawa" then
			colors = require("kanagawa.colors").setup({ theme = "wave" }).palette
		elseif theme == "tokyonight" then
			colors = {
				blue = "#65D1FF",
				green = "#3EFFDC",
				violet = "#FF61EF",
				yellow = "#FFDA7B",
				red = "#FF4A4A",
				fg = "#c3ccdc",
				bg = "#112638",
				inactive_bg = "#2c3043",
			}

			my_lualine_theme = {
				normal = {
					a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				insert = {
					a = { bg = colors.green, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				visual = {
					a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				command = {
					a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				replace = {
					a = { bg = colors.red, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				inactive = {
					a = { bg = colors.inactive_bg, fg = colors.fg, gui = "bold" },
					b = { bg = colors.inactive_bg, fg = colors.fg },
					c = { bg = colors.inactive_bg, fg = colors.fg },
				},
			}
		end

		-- configure lualine with modified theme
		lualine.setup({
			options = {
				theme = my_lualine_theme,
				-- theme = "gruvbox_dark",

				-- component_separators = { left = "│", right = "│" },
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				globalstatus = true,
				--
				--section_separators = {
				--  left = '',
				--  right = ''
				--}, -- BubbleButt

				disabled_filetypes = {
					statusline = {
						"packer",
						"NVimTree",
					},
					winbar = {
						"packer",
						"NVimTree",
					},
				},
			},
			sections = {
				lualine_a = { { "mode" } },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { { "filename", path = 0 } },
				lualine_x = {
					{
						function()
							local rec_reg = vim.fn.reg_recording()
							if rec_reg ~= "" then
								return "Recording @" .. rec_reg
							else
								return ""
							end
						end,
					},
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
					{ "encoding" },
					{ "fileformat" },
					{ "filetype" },
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},

			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}
