local M = {}

M.setup = function()
	-- Set up your autocommands
	vim.api.nvim_create_autocmd("User", {
		pattern = "ZenModeEnter",
		callback = function()
			if vim.env.TMUX then
				vim.fn.system("tmux resize-pane -Z")
				vim.fn.system("tmux set status off")
				-- print("ZenModeEnter triggered")
			end
		end,
	})

	vim.api.nvim_create_autocmd("User", {
		pattern = "ZenModeLeave",
		callback = function()
			if vim.env.TMUX then
				vim.fn.system("tmux resize-pane -Z")
				vim.fn.system("tmux set status on")
				-- print("ZenModeLeave triggered")
			end
		end,
	})

	-- Create a wrapper command to toggle Zen Mode and emit events
	vim.api.nvim_create_user_command("ZenWithTmux", function()
		local zen_mode = require("zen-mode")
		if zen_mode.is_open() then
			-- Leaving Zen Mode
			vim.api.nvim_exec_autocmds("User", { pattern = "ZenModeLeave" })
			zen_mode.toggle()
		else
			-- Entering Zen Mode
			vim.api.nvim_exec_autocmds("User", { pattern = "ZenModeEnter" })
			zen_mode.toggle()
		end
	end, {})
end

return M
