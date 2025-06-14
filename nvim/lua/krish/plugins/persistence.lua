return {
	"folke/persistence.nvim",
	event = "BufReadPre", -- lazy load before buffers are loaded
	opts = {
		options = { "buffers", "curdir", "tabpages", "winsize" }, -- what to save
	},
	keys = {
		{
			"<leader>wr",
			function()
				require("persistence").load()
			end,
			desc = "Restore session",
		},
		{
			"<leader>wl",
			function()
				require("persistence").load({ last = true })
			end,
			desc = "Restore last session",
		},
		{
			"<leader>wq",
			function()
				require("persistence").stop()
			end,
			desc = "Stop saving session",
		},
	},
}
