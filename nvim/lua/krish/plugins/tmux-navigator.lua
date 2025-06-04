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
			"<M-h>",
			"<cmd>TmuxNavigateLeft<CR>",
			{ desc = "Goto left pane", noremap = true, silent = true }
		)
		keymap.set(
			"n",
			"<M-j>",
			"<cmd>TmuxNavigateDown<CR>",
			{ desc = "Goto below pane", noremap = true, silent = true }
		)
		keymap.set("n", "<M-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "Goto above pane", noremap = true, silent = true })
		keymap.set(
			"n",
			"<M-l>",
			"<cmd>TmuxNavigateRight<CR>",
			{ desc = "Goto right pane", noremap = true, silent = true }
		)
		keymap.set(
			"n",
			"<M-o>",
			"<cmd>TmuxNavigatePrevious<CR>",
			{ desc = "Goto prev pane", noremap = true, silent = true }
		)
	end,
}
