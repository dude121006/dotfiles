local M = {}

function M.man_hover()
	local word = vim.fn.expand("<cword>")
	-- This mimics `:Man printf` (section 3) behavior
	local output = vim.fn.systemlist({ "man", "3", word })
	if vim.v.shell_error == 0 and #output > 0 then
		vim.lsp.util.open_floating_preview(output, "man")
	else
		vim.lsp.buf.hover()
	end
end

return M
