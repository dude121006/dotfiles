require("krish.core")
require("krish.lazy")
-- vim.cmd("colorscheme gruvbox-material") -- Set TokyoNight as the default colorscheme
vim.cmd("colorscheme catppuccin-mocha") -- Set TokyoNight as the default colorscheme

vim.filetype.add({
	extension = {
		yara = "yara",
	},
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "rounded", -- Optional: Makes the border rounded
	focusable = false, -- Prevents accidental focus
	max_width = 80, -- Adjust width if needed
	max_height = 20, -- Adjust height if needed
	offset_x = 0, -- Moves it horizontally (left/right)
	offset_y = 1, -- Moves it **1 line down**
})

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

local clients = vim.lsp.get_active_clients()

-- local function man_popup_for_c_function()
-- 	local word = vim.fn.expand("<cword>")
-- 	-- Try opening the man page using :Man (section 3 for C functions)
-- 	local man_buf = vim.api.nvim_create_buf(false, true)
-- 	local output = vim.fn.systemlist({ "man", "3", word })
-- 	if vim.v.shell_error == 0 and #output > 0 then
-- 		vim.api.nvim_buf_set_lines(man_buf, 0, -1, false, output)
-- 		vim.lsp.util.open_floating_preview(output, "man")
-- 	else
-- 		-- Fallback to LSP hover if man page doesn't exist
-- 		vim.lsp.buf.hover()
-- 	end
-- end

-- Map gh to this
-- vim.keymap.set("n", "gh", man_popup_for_c_function, { desc = "Show man page or LSP hover" })
