local vim = vim

-- Create the module table
local M = {}

function M.compile_and_run()
	local original_ext = vim.fn.expand("%:e") -- Keep this for other specific extensions if needed
	local current_filetype = vim.bo.filetype -- Get the current buffer's filetype (e.g., "audio", "video")
	local file = vim.fn.expand("%:p")
	local filename = vim.fn.expand("%:t:r")
	local cmd = ""

	if original_ext == "c" then
		cmd = string.format("gcc %s -o %s && ./%s", file, filename, filename)
	elseif original_ext == "cpp" then
		cmd = string.format("g++ %s -o %s && ./%s", file, filename, filename)
	elseif original_ext == "py" then
		cmd = string.format("python3 %s", file)
	elseif original_ext == "java" then
		cmd = string.format("javac %s && java %s", file, filename)
	elseif original_ext == "rs" then
		cmd = string.format("rustc %s && ./%s", file, filename)
	elseif original_ext == "sh" then
		cmd = string.format("bash %s", file)
	elseif original_ext == "lua" then
		cmd = string.format("lua %s", file)
	elseif current_filetype == "video" then
		cmd = string.format("mpv %s", vim.fn.shellescape(file))
		vim.fn.jobstart(cmd, { detach = true })
		return
	elseif current_filetype == "audio" then
		cmd = string.format("mpv %s", vim.fn.shellescape(file))
		vim.fn.jobstart(cmd, { detach = true })
		return
	elseif current_filetype == "png" or current_filetype == "jpg" or current_filetype == "jpeg" then
		cmd = string.format("mpv %s --keep-open --ontop", vim.fn.shellescape(file))
		vim.fn.jobstart(cmd, { detach = true })
		return
	else
		vim.notify(
			"Unsupported filetype: " .. original_ext .. " (Detected as: " .. current_filetype .. ")",
			vim.log.levels.WARN
		)
		return
	end

	local buf = vim.api.nvim_create_buf(false, true)
	local output_lines = {}
	local job_id = nil -- Store the job ID so we can kill it later

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
		focusable = true,
	})

	-- Start the job and stream output
	job_id = vim.fn.jobstart(cmd, {
		on_stdout = function(_, data)
			if data then
				-- Make buffer modifiable temporarily
				vim.api.nvim_buf_set_option(buf, "modifiable", true)
				for _, line in ipairs(data) do
					if line ~= "" then
						table.insert(output_lines, line)
						vim.api.nvim_buf_set_lines(buf, -1, -1, false, { line })
					end
				end
				-- Make buffer non-modifiable again
				vim.api.nvim_buf_set_option(buf, "modifiable", false)
			end
		end,
		on_stderr = function(_, data)
			if data then
				-- Make buffer modifiable temporarily
				vim.api.nvim_buf_set_option(buf, "modifiable", true)
				for _, line in ipairs(data) do
					if line ~= "" then
						table.insert(output_lines, "ERROR: " .. line)
						vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "ERROR: " .. line })
					end
				end
				-- Make buffer non-modifiable again
				vim.api.nvim_buf_set_option(buf, "modifiable", false)
			end
		end,
		on_exit = function(_, code)
			-- Make buffer modifiable temporarily
			vim.api.nvim_buf_set_option(buf, "modifiable", true)
			vim.api.nvim_buf_set_lines(
				buf,
				-1,
				-1,
				false,
				{ "", "[Process exited with code " .. code .. "]", "[Press q to close]" }
			)
			-- Make buffer non-modifiable again
			vim.api.nvim_buf_set_option(buf, "modifiable", false)
		end,
	})

	-- Function to close window and kill process if needed
	local function close_and_cleanup()
		-- Kill the job if it's still running
		if job_id and vim.fn.jobwait({ job_id }, 0)[1] == -1 then
			vim.fn.jobstop(job_id)
			vim.notify("Stopped running process (job ID: " .. job_id .. ")", vim.log.levels.INFO)
		end
		-- Close the window
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end

	-- Close on `q` with cleanup
	vim.keymap.set("n", "q", close_and_cleanup, { buffer = buf, nowait = true, silent = true })

	-- Also cleanup when the window is closed by other means (like :q, <C-w>c, etc.)
	vim.api.nvim_create_autocmd("WinClosed", {
		pattern = tostring(win),
		once = true,
		callback = function()
			if job_id and vim.fn.jobwait({ job_id }, 0)[1] == -1 then
				vim.fn.jobstop(job_id)
				vim.notify("Stopped running process (job ID: " .. job_id .. ")", vim.log.levels.INFO)
			end
		end,
	})

	-- Resize keys
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
		vim.api.nvim_win_set_config(win, config) -- Fixed: use 'config' not 'win_config'
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
