vim.g.tmux_navigator_no_mappings = 1

return {
	"christoomey/vim-tmux-navigator", -- tmux & split window navigation
	config = function()
		local keymap = vim.keymap

		-- keymap.set(
		-- 	"n",
		-- 	"<leader>h",
		-- 	"<cmd>TmuxNavigateLeft<CR>",
		-- 	{ desc = "Goto left pane", noremap = true, silent = true }
		-- )
		-- keymap.set(
		-- 	"n",
		-- 	"<leader>j",
		-- 	"<cmd>TmuxNavigateDown<CR>",
		-- 	{ desc = "Goto below pane", noremap = true, silent = true }
		-- )
		-- keymap.set(
		-- 	"n",
		-- 	"<leader>k",
		-- 	"<cmd>TmuxNavigateUp<CR>",
		-- 	{ desc = "Goto above pane", noremap = true, silent = true }
		-- )
		-- keymap.set(
		-- 	"n",
		-- 	"<leader>l",
		-- 	"<cmd>TmuxNavigateRight<CR>",
		-- 	{ desc = "Goto right pane", noremap = true, silent = true }
		-- )
		-- keymap.set(
		-- 	"n",
		-- 	"<leader>.",
		-- 	"<cmd>TmuxNavigatePrevious<CR>",
		-- 	{ desc = "Goto prev pane", noremap = true, silent = true }
		-- )
		keymap.set(
			"n",
			"<D-h>",
			"<cmd>TmuxNavigateLeft<CR>",
			{ desc = "Goto left pane", noremap = true, silent = true }
		)
		keymap.set(
			"n",
			"<D-j>",
			"<cmd>TmuxNavigateDown<CR>",
			{ desc = "Goto below pane", noremap = true, silent = true }
		)
		keymap.set("n", "<D-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "Goto above pane", noremap = true, silent = true })
		keymap.set(
			"n",
			"<D-l>",
			"<cmd>TmuxNavigateRight<CR>",
			{ desc = "Goto right pane", noremap = true, silent = true }
		)
		keymap.set(
			"n",
			"<D-o>",
			"<cmd>TmuxNavigatePrevious<CR>",
			{ desc = "Goto prev pane", noremap = true, silent = true }
		)
	end,
}
