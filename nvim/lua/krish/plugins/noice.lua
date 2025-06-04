return {
	"folke/noice.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim", -- If you need nui.nvim, uncomment this
		"rcarriga/nvim-notify", -- If you need nvim-notify, uncomment this
	},
	config = function()
		require("noice").setup({
			lsp = {
				hover = {
					enabled = true,
					border = "rounded",
					view = "hover",
					opts = {
						lang = "markdown",
						size = { max_width = 80, max_height = 20 },
						win_options = {
							concealcursor = "n",
							conceallevel = 3,
							winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
						},
					},
				},
				signature = {
					enabled = true,
					opts = {
						border = "rounded",
						position = { row = 2, col = 0 },
						win_options = {
							concealcursor = "n",
							conceallevel = 3,
						},
					},
				},
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				documentation = {
					view = "hover",
					opts = {
						lang = "markdown",
						replace = true,
						render = "plain",
						format = { "{message}" },
						win_options = { concealcursor = "n", conceallevel = 3 },
					},
				},
			},
		})

		vim.keymap.set("n", "<leader><leader>", "<cmd>NoiceDismiss<cr>", { desc = "Noice Dismiss" })
	end,
}
