return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			-- javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			svelte = { "eslint_d" },
			python = { "pylint_venv" },
			java = {},
		}

		-- # custom linter to make pylint use the .venv instead of global python packages
		lint.linters.pylint_venv = {
			cmd = function()
				local cwd = vim.fn.getcwd()
				local pylint = cwd .. "/.venv/bin/pylint"
				if vim.fn.executable(pylint) == 1 then
					return pylint
				end
				return "pylint" -- fallback to global pylint if .venv not found
			end,
			stdin = false,
			args = {
				"--msg-template='{path}:{line}:{column}: {msg_id} ({symbol}) {msg}'",
				"--disable=C0114,C0115,C0116", -- Optional: disable docstring warnings
			},
			ignore_exitcode = true,
			parser = require("lint.parser").from_errorformat("%f:%l:%c: %m", {
				source = "pylint",
				severity = vim.diagnostic.severity.WARN,
			}),
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>L", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
