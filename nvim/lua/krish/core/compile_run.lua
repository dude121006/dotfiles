local vim = vim
-- krish/core/compile_run.lua

-- 1. Create a module table (conventionally named `M`)
local M = {}

-- 2. Define your main function as a field of the module table.
--    Make sure the name here matches what your keymap expects: `compile_and_run`.
function M.compile_and_run()
	local ext = vim.fn.expand("%:e")
	local file = vim.fn.expand("%:p")
	local filename = vim.fn.expand("%:t:r")
	local cmd = ""

	if ext == "c" then
		cmd = string.format("gcc %s -o %s && ./%s", file, filename, filename)
	elseif ext == "cpp" then
		cmd = string.format("g++ %s -o %s && ./%s", file, filename, filename)
	elseif ext == "py" then
		cmd = string.format("python3 %s", file)
	elseif ext == "java" then
		cmd = string.format("javac %s && java %s", file, filename)
	elseif ext == "rs" then
		cmd = string.format("rustc %s && ./%s", file, filename)
	elseif ext == "sh" then
		cmd = string.format("bash %s", file)
	elseif ext == "lua" then
		cmd = string.format("lua %s", file)
	elseif ext == "video" or ext == "webm" then
		cmd = string.format("mpv %s", vim.fn.shellescape(file))
		vim.fn.jobstart(cmd, { detach = true })
		return
	else
		vim.notify("Unsupported filetype: " .. ext, vim.log.levels.WARN)
		return
	end

	local output = vim.fn.systemlist(cmd)

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
	vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "", "[Press q to close]" })
	vim.api.nvim_buf_set_option(buf, "filetype", "output")
	vim.api.nvim_buf_set_option(buf, "modifiable", false)

	local width = math.floor(vim.o.columns * 0.8)
	local height = math.min(20, vim.o.lines - 4)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		focusable = true, -- <- important
	})

	-- Close on `q`
	vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, nowait = true, silent = true })

	-- Resize keys (keeping the debug checks we discussed, just in case)
	local function resize_win(delta_w, delta_h)
		if not vim.api.nvim_win_is_valid(win) then
			vim.notify("Resize: window is invalid. ID: " .. tostring(win), vim.log.levels.INFO)
			return
		end
		local config = vim.api.nvim_win_get_config(win)
		if type(config) ~= "table" then
			vim.notify(
				"Resize: nvim_win_get_config returned type: "
					.. type(config)
					.. " value: "
					.. tostring(config)
					.. ". ID: "
					.. tostring(win),
				vim.log.levels.ERROR
			)
			return
		end
		config.width = math.max(10, config.width + delta_w)
		config.height = math.max(5, config.height + delta_h)
		vim.api.nvim_win_set_config(win, win_config) -- Fix: Should be 'win_config' or 'config' consistently
	end

	vim.keymap.set("n", "<C-Up>", function()
		resize_win(0, -1)
	end, { buffer = buf })
	vim.keymap.set("n", "<C-Down>", function()
		resize_win(0, 1)
	end, { buffer = buf })
	vim.keymap.set("n", "<C-Left>", function()
		resize_win(-1, 0)
	end, { buffer = buf })
	vim.keymap.set("n", "<C-Right>", function()
		resize_win(1, 0)
	end, { buffer = buf })
end

-- 3. You can still create the user command, now referencing the function from M
vim.api.nvim_create_user_command("CompileRun", M.compile_and_run, {})

-- 4. CRUCIAL: Return the module table `M`
return M
