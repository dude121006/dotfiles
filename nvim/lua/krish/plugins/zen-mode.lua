return {
	"folke/zen-mode.nvim",
	opts = {
		on_open = function()
			vim.api.nvim_exec_autocmds("User", { pattern = "ZenModeEnter" })
		end,
		on_close = function()
			vim.api.nvim_exec_autocmds("User", { pattern = "ZenModeLeave" })
		end,
	},
	keys = {
		{ "<leader>z", "<cmd>ZenMode<CR>", desc = "Toggle Zen Mode" },
	},
}
