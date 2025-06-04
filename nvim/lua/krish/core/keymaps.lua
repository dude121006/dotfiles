-- Set leader key to Space
vim.g.mapleader = " "

local keymap = vim.keymap

-- Enable highlighting search matches
vim.o.hlsearch = true

-- Insert Mode Mappings
keymap.set("i", "fj", "<ESC>", { desc = "Exit insert mode", noremap = true, silent = true })

-- Normal Mode Mappings
keymap.set("n", "J", "5j", { desc = "Down 5 lines", noremap = true, silent = true })
keymap.set("n", "K", "5k", { desc = "Up 5 lines", noremap = true, silent = true })
keymap.set("n", "<leader>J", "J", { desc = "Join lines", noremap = true, silent = true })
keymap.set("n", "<leader>K", "K", { desc = "", noremap = true, silent = true })
-- keymap.set("n", "<C-j>", "<C-d>zz", { desc = "Down a page", noremap = true, silent = true })
-- keymap.set("n", "<C-k>", "<C-u>zz", { desc = "Up a page", noremap = true, silent = true })
keymap.set("n", "<C-j>", "<C-d>", { desc = "Down a page", noremap = true, silent = true })
keymap.set("n", "<C-k>", "<C-u>", { desc = "Up a page", noremap = true, silent = true })
keymap.set("n", "<leader>to", ":tabo<CR>", { desc = "", noremap = true, silent = true })
keymap.set("n", "<leader>/", ":noh<CR>", { desc = "Clear highlighting", noremap = true, silent = true })
keymap.set("n", "<leader><CR>", ":noh<CR>", { desc = "", noremap = true, silent = true })
keymap.set("n", "<C-m>", "gc", { desc = "Comment", noremap = true, silent = true })
keymap.set("v", "<leader>C", 'ggVG"+y', { desc = "Select everything", noremap = true, silent = true })

-- Visual Mode Mappings
keymap.set("v", "J", "5j", { desc = "Down 5 lines", noremap = true, silent = true })
keymap.set("v", "K", "5k", { desc = "Up 5 lines", noremap = true, silent = true })
keymap.set("v", "<C-j>", "<C-d>zz", { desc = "Down a page", noremap = true, silent = true })
keymap.set("v", "<C-k>", "<C-u>zz", { desc = "Up a page", noremap = true, silent = true })
keymap.set("v", "<leader>y", '"+y', { desc = "Copy into clipboard", noremap = true, silent = true })
keymap.set("v", "<leader>p", '"_dP', { desc = "Paste into void reg", noremap = true, silent = true })
keymap.set("v", "<leader>d", '"_d', { desc = "Delete into void reg", noremap = true, silent = true })

-- Quit files
keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit file", noremap = true, silent = true })
keymap.set("n", "<leader>Q", "<cmd>qa<CR>", { desc = "Quit all files", noremap = true, silent = true })
keymap.set("n", "<leader>W", "<cmd>wqa<CR>", { desc = "Write and quit all files", noremap = true, silent = true })

-- Splits
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- Tabs
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- automation
-- keymap.set("n", "<A-k>", "<cmd>make<CR>", { desc = "Run make file", noremap = true, silent = true }) --  go to previous tab
keymap.set("n", "<leader>k", "<cmd>make<CR>", { desc = "Run make file", noremap = true, silent = true }) --  go to previous tab
keymap.set(
	"n",
	"<leader>rr",
	":lua require('krish.core.compile_run').compile_and_run()<CR>",
	{ desc = "Run current file", noremap = true, silent = true }
)
keymap.set("n", "<leader>;", "<cmd>w<CR>", { desc = "Save current file", noremap = true, silent = true }) --  go to previous tab
keymap.set("n", "<M-;>", "<cmd>make run<CR>", { desc = "Run 'make run' file", noremap = true, silent = true }) --  go to previous tab

-- buffers
keymap.set("n", "<leader>o", function()
	local bufnr = vim.fn.bufnr("#") -- Get the alternate buffer number
	if bufnr > 0 then
		vim.cmd("buffer " .. bufnr) -- Switch to the alternate buffer
	else
		print("No alternate buffer")
	end
end, { desc = "Go to Last Buffer" })

--
--
-- terminal splits
vim.keymap.set("n", "<leader>ts", function()
	vim.cmd("botright split | terminal")
end, { desc = "Open terminal below" })

vim.keymap.set("n", "<leader>tv", function()
	vim.cmd("botright vsplit | terminal")
end, { desc = "Open terminal right" })

--
-- terminal navigation
vim.keymap.set("t", "<M-h>", [[<C-\><C-n><C-w>h]], { noremap = true, silent = true })
vim.keymap.set("t", "<M-j>", [[<C-\><C-n><C-w>j]], { noremap = true, silent = true })
vim.keymap.set("t", "<M-k>", [[<C-\><C-n><C-w>k]], { noremap = true, silent = true })
vim.keymap.set("t", "<M-l>", [[<C-\><C-n><C-w>l]], { noremap = true, silent = true })

-- diagnostics overlay
vim.keymap.set("n", "<leader>,s", function()
	vim.diagnostic.open_float({ border = "rounded" })
end, { noremap = true, silent = true, desc = "Show diagnostics overlay" })

-- folds
vim.keymap.set("n", "zc", "zc", { noremap = true, desc = "Close fold" })
vim.keymap.set("n", "zo", "zo", { noremap = true, desc = "Open fold" })
vim.keymap.set("n", "za", "za", { noremap = true, desc = "Toggle fold" })
vim.keymap.set("n", "zR", "zR", { noremap = true, desc = "Open all folds" })
vim.keymap.set("n", "zM", "zM", { noremap = true, desc = "Close all folds" })
