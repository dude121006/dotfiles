return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
		"nvim-telescope/telescope-dap.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		-- local transform_mod = require("telescope.actions.mt").transform_mod
		--
		-- local trouble = require("trouble")
		-- local trouble_telescope = require("trouble.sources.telescope")
		--
		-- -- or create your custom action
		-- local custom_actions = transform_mod({
		--   open_trouble_qflist = function(prompt_bufnr)
		--     trouble.toggle("quickfix")
		--   end,
		-- })

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<M-k>"] = actions.move_selection_previous, -- move to prev result
						["<M-j>"] = actions.move_selection_next, -- move to next result
						-- ["<A-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
						-- ["<C-t>"] = trouble_telescope.open,
					},
				},
			},
		})

		telescope.load_extension("fzf")

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>fj", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
		keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
		keymap.set("n", "<leader>fl", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Find document symbols" })

		-- for cpp manual using cppman
		keymap.set("n", "<leader>fm", function()
			local word = vim.fn.expand("<cword>")
			vim.cmd("split") -- open a horizontal terminal split
			vim.cmd("terminal cppman " .. word)
			vim.cmd("startinsert") -- auto enter insert mode in terminal
		end, { noremap = true, silent = true, desc = "Cpp manual" })
		-- keymap.set("n", "<leader>fD", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Find document symbols" })
		keymap.set(
			"n",
			"<leader>fs",
			"<cmd>Telescope current_buffer_fuzzy_find<cr>",
			{ desc = "Current Buffer Fuzzy Find" }
		)

		--
		--
		-- Telescope dap
		vim.keymap.set("n", "<leader>fdl", ":Telescope dap list_breakpoints<CR>", { desc = "Debug: List Breakpoints" })

		-- Additional useful telescope-dap commands
		vim.keymap.set("n", "<leader>fdc", ":Telescope dap commands<CR>", { desc = "Debug: Commands" })
		vim.keymap.set("n", "<leader>fdC", ":Telescope dap configurations<CR>", { desc = "Debug: Configurations" })
		vim.keymap.set("n", "<leader>fdv", ":Telescope dap variables<CR>", { desc = "Debug: Variables" })
		vim.keymap.set("n", "<leader>fdf", ":Telescope dap frames<CR>", { desc = "Debug: Frames" })
	end,
}
