return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				javascript = { "prettier" },
				lua = { "stylua" },
				python = { "isort", "black" },
				c = { "clangformat" },
				cpp = { "clangformat" },
				java = { "jdtls" },
				yara = { "prettier" },
				yar = { "prettier" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			},
			-- formatters = {
			-- 	clangformat = {
			-- 		command = "clang-format",
			-- 		args = {
			-- 			"--style=file",
			-- 		},
			-- 	},
			-- },
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
