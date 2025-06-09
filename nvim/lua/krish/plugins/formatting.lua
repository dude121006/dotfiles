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
				timeout_ms = 5000,
			},
			formatters = {
				black = {
					command = function()
						local venv = os.getenv("VIRTUAL_ENV")
						if venv then
							return venv .. "/bin/python"
						end
						return "python"
					end,
					args = { "-m", "black", "--stdin-filename", "$FILENAME", "--quiet", "--line-length", "120", "-" },
					stdin = true,
					timeout_ms = 8000,
					-- Additional fixes for race conditions:
					exit_codes = { 0 },
					env = {
						PYTHONUNBUFFERED = "1",
					},
				},
				isort = {
					command = function()
						local venv = os.getenv("VIRTUAL_ENV")
						if venv then
							return venv .. "/bin/python"
						end
						return "python"
					end,
					args = { "-m", "isort", "--stdout", "--filename", "$FILENAME", "-" },
					stdin = true,
					timeout_ms = 5000, -- Keep as is, isort is faster
					-- Additional fixes:
					exit_codes = { 0 },
					env = {
						PYTHONUNBUFFERED = "1",
					},
				},
			},
			log_level = vim.log.levels.WARN, -- FIXED: Reduced from DEBUG to WARN (less noise)
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 10000, -- FIXED: Increased from 1000ms
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
