-- Ensure global filetype detection is enabled.
-- This is often handled by plugin managers like lazy.nvim, but good to be explicit.
vim.cmd("filetype plugin indent on")

-- Autocmd to explicitly set filetype for common image extensions.
-- This runs *before* the buffer is read, ensuring the filetype is set early.
vim.api.nvim_create_autocmd("BufReadPre", {
	group = vim.api.nvim_create_augroup("MyImageFileType", { clear = true }),
	pattern = { "*.jpg", "*.jpeg", "*.png", "*.gif", "*.webp", "*.bmp", "*.ico" },
	callback = function()
		local filename = vim.fn.expand("<afile>")
		local ext = filename:match("%.([^.]+)$") -- Extract file extension
		if ext then
			-- Set filetype based on the actual extension (e.g., 'jpeg' for .jpg/.jpeg, 'png' for .png)
			if ext:lower() == "jpg" or ext:lower() == "jpeg" then
				vim.bo.filetype = "jpeg"
			else
				vim.bo.filetype = ext:lower() -- For other image types like png, gif etc.
			end
		end
	end,
})

-- Your existing requires
require("krish.core")
require("krish.lazy")

-- Your existing colorscheme settings
vim.cmd("colorscheme rose-pine-main")

-- Your existing LSP hover handler configuration
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "rounded",
	focusable = false,
	max_width = 80,
	max_height = 20,
	offset_x = 0,
	offset_y = 1,
})

-- Your existing diagnostic configuration
vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

local clients = vim.lsp.get_active_clients()
