return {
	"kevinhwang91/nvim-ufo",
	dependencies = { "nvim-treesitter/nvim-treesitter", "kevinhwang91/promise-async" }, -- UFO requires Treesitter for its best folding
	event = "BufReadPost", -- Load after a buffer is read
	opts = {
		-- Customize UFO options here
		-- See section 3 for more details
		provider_selector = function(bufnr, ft, buftype)
			-- This is a crucial part for UFO to choose the folding provider
			-- It prioritizes Treesitter folding if available, then fallback to indent or syntax
			local ufo = require("ufo")
			if ft == "python" or ft == "typescript" or ft == "javascript" or ft == "tsx" then
				-- Prioritize Treesitter for these filetypes
				return { "treesitter", "indent" }
			else
				-- For other filetypes, try Treesitter, then indent
				return { "treesitter", "indent" }
			end
		end,
		-- Optional: Customize fold text (what appears on folded lines)
		fold_virt_text_handler = function(virt_text, lnum, endLnum, width, truncate)
			local newVirtText = {}
			local suffix = ("   %d lines "):format(endLnum - lnum) -- Example:  10 lines
			local sufWidth = vim.fn.strdisplaywidth(suffix)
			local targetWidth = width - sufWidth
			local curWidth = 0
			for _, chunk in ipairs(virt_text) do
				local chunkText = chunk[1]
				local chunkWidth = vim.fn.strdisplaywidth(chunkText)
				if targetWidth > curWidth + chunkWidth then
					table.insert(newVirtText, chunk)
				else
					chunkText = truncate(chunkText, targetWidth - curWidth)
					table.insert(newVirtText, { chunkText, chunk[2] })
					curWidth = curWidth + vim.fn.strdisplaywidth(chunkText)
					break
				end
				curWidth = curWidth + chunkWidth
			end
			table.insert(newVirtText, { suffix, "MoreMsg" }) -- "MoreMsg" is a highlight group
			return newVirtText
		end,
	}, -- This closes the 'opts' table
	config = function(_, opts)
		-- Setup UFO with the options
		require("ufo").setup(opts)

		-- IMPORTANT: You must set foldmethod to "manual" when using UFO
		-- UFO will manage the actual folding levels based on its providers.
		vim.opt.foldmethod = "manual"
		-- Optional: Set a high foldlevel to keep most folds open by default
		vim.opt.foldlevel = 99
		-- Optional: Show the fold column
		vim.opt.foldcolumn = "1"
	end, -- This closes the 'config' function
} -- <--- ADD THIS CLOSING CURLY BRACE!
