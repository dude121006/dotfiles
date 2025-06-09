local vim = vim
-- Ensure global filetype detection is enabled.
-- This is often handled by plugin managers like lazy.nvim, but good to be explicit.
vim.cmd("filetype plugin indent on")

-- Autocmd to explicitly set filetype for common image extensions.
-- This runs *before* the buffer is read, ensuring the filetype is set early.
vim.api.nvim_create_autocmd("BufReadPre", {
	group = vim.api.nvim_create_augroup("MyMediaFileType", { clear = true }),
	pattern = {
		-- Images
		"*.jpg",
		"*.jpeg",
		"*.png",
		"*.gif",
		"*.webp",
		"*.bmp",
		"*.ico",
		-- Videos
		"*.mp4",
		"*.webm",
		"*.avi",
		"*.mov",
		"*.mkv",
		"*.flv",
		"*.wmv",
		"*.m4v",
		-- Audio
		"*.mp3",
		"*.wav",
		"*.flac",
		"*.aac",
		"*.ogg",
		"*.m4a",
		"*.wma",
		"*.opus",
	},
	callback = function()
		local filename = vim.fn.expand("<afile>")
		local ext = filename:match("%.([^.]+)$") -- Extract file extension
		if ext then
			ext = ext:lower()
			-- Video extensions
			if
				ext == "mp4"
				or ext == "webm"
				or ext == "avi"
				or ext == "mov"
				or ext == "mkv"
				or ext == "flv"
				or ext == "wmv"
				or ext == "m4v"
			then
				vim.bo.filetype = "video"
			-- Audio extensions
			elseif
				ext == "mp3"
				or ext == "wav"
				or ext == "flac"
				or ext == "aac"
				or ext == "ogg"
				or ext == "m4a"
				or ext == "wma"
				or ext == "opus"
			then
				vim.bo.filetype = "audio"
			-- Image extensions
			elseif ext == "jpg" or ext == "jpeg" then
				vim.bo.filetype = "jpeg"
			elseif ext == "png" then
				vim.bo.filetype = "png" -- For other image types like png, gif etc.
			else
				vim.bo.filetype = ext -- For other image types like png, gif etc.
			end
		end
	end,
})

-- Your existing requires
require("krish.core")
require("krish.lazy")

-- Your existing colorscheme settings
-- vim.cmd("colorscheme rose-pine-main")
vim.cmd("colorscheme kanagawa-wave")

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
