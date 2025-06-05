local vim = vim

return {
	{
		"mfussenegger/nvim-dap",
		-- Specify dependencies that nvim-dap relies on
		dependencies = {
			"rcarriga/nvim-dap-ui", -- For the visual debugger UI
			"nvim-neotest/nvim-nio", -- A dependency required by nvim-dap-ui
			"jay-babu/mason-nvim-dap.nvim", -- (Optional) For easier installation of debuggers (e.g., debugpy, cppdbg)
			"theHamsta/nvim-dap-virtual-text", -- (Optional) Shows variable values inline in your code
		},
		-- Configure the plugin when it loads
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			local dap_virtual_text = require("nvim-dap-virtual-text") -- For inline variable display

			-- --- DAP Adapters Configuration ---
			-- Define how Neovim's DAP client connects to specific debuggers

			-- Python Debugger (debugpy)
			dap.adapters.python = {
				type = "executable",
				command = "python", -- Use 'python' assuming it's in your PATH, or full path to your Python executable
				args = { "-m", "debugpy.adapter" },
			}

			-- C++ Debugger (CodeLLDB via mason.nvim)
			-- Ensure 'codelldb' is installed via :MasonInstall codelldb
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					-- Path to the codelldb executable installed by mason.nvim
					command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
					args = { "--port", "${port}" },
				},
			}

			-- Alternative: cppdbg adapter (if using cppdbg instead of codelldb)
			dap.adapters.cppdbg = {
				id = "cppdbg",
				type = "executable",
				command = vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7",
			}

			-- --- DAP Configurations (Launch/Attach settings for different languages) ---
			-- Define how to launch or attach to a program for debugging

			-- Python Configurations
			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "Launch Current Python File",
					program = "${file}", -- Debugs the currently open Python file
					pythonPath = function()
						-- Check if we're in a virtual environment
						local venv = os.getenv("VIRTUAL_ENV")
						if venv then
							return venv .. "/bin/python"
						else
							-- Fallback to system python
							return "python"
						end
					end,
				},
				{
					type = "python",
					request = "launch",
					name = "Launch Python Module",
					module = function()
						return vim.fn.input("Module name: ")
					end,
					pythonPath = function()
						local venv = os.getenv("VIRTUAL_ENV")
						if venv then
							return venv .. "/bin/python"
						else
							return "python"
						end
					end,
				},
			}

			-- C++ Configurations
			dap.configurations.cpp = {
				{
					name = "Launch C++ Executable",
					type = "codelldb", -- or "cppdbg" if using that adapter
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},
				},
				{
					name = "Launch C++ with Args",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = function()
						local args_string = vim.fn.input("Arguments: ")
						return vim.split(args_string, " ")
					end,
				},
			}

			-- C configurations (same as C++)
			dap.configurations.c = dap.configurations.cpp

			-- --- nvim-dap-ui Configuration ---
			-- Setup the visual interface for the debugger
			dapui.setup({
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.25 }, -- Variables in current scope
							{ id = "breakpoints", size = 0.25 }, -- List of breakpoints
							{ id = "stacks", size = 0.25 }, -- Call stack
							{ id = "watches", size = 0.25 }, -- Custom watch expressions
						},
						size = 40, -- Initial width of the side panel
						position = "right",
					},
					{
						elements = {
							{ id = "repl", size = 0.5 }, -- Debugger REPL
							{ id = "console", size = 0.5 }, -- Debugger console output
						},
						size = 10, -- Initial height of the bottom panel
						position = "bottom",
					},
				},
				-- FIXED: Proper controls configuration
				controls = {
					element = "repl", -- Should be a string, not a table
					enabled = true,
					icons = {
						pause = "",
						play = "",
						step_into = "",
						step_over = "",
						step_out = "",
						step_back = "",
						run_last = "",
						terminate = "",
					},
				},
				render = {
					max_type_length = nil,
					max_value_length = nil,
				},
				-- Additional UI options
				icons = { expanded = "", collapsed = "", current_frame = "" },
				mappings = {
					expand = { "<CR>", "<2-LeftMouse>" },
					open = "o",
					remove = "d",
					edit = "e",
					repl = "r",
					toggle = "t",
				},
				floating = {
					max_height = nil,
					max_width = nil,
					border = "single",
					mappings = {
						close = { "q", "<Esc>" },
					},
				},
			})

			-- --- nvim-dap-virtual-text Configuration ---
			-- Setup inline display of variable values
			dap_virtual_text.setup({
				enabled = true, -- Enable/disable virtual text
				enabled_commands = true, -- Create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle
				highlight_changed_variables = true, -- Highlight changed variables
				highlight_new_as_changed = false, -- Highlight new variables as changed
				show_stop_reason = true, -- Show stop reason when stopped
				commented = false, -- Prefix virtual text with comment string
				only_first_definition = true, -- Only show virtual text at first definition
				all_references = false, -- Show virtual text on all references
				clear_on_continue = false, -- Clear virtual text on continue
				display_callback = function(variable, buf, stackframe, node, options)
					if options.virt_text_pos == "inline" then
						return " = " .. variable.value
					else
						return variable.name .. " = " .. variable.value
					end
				end,
				virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",
				all_frames = false, -- Show virtual text for all stack frames
				virt_lines = false, -- Show virtual lines instead of virtual text
				virt_text_win_col = nil, -- Position the virtual text at a fixed window column
			})

			-- --- DAP Listeners (Auto-open/close UI on debug session start/end) ---
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			-- --- User-Friendly Keymaps for Debugging ---
			-- More intuitive and memorable key combinations

			-- Core debugging controls (traditional debugger F-key layout)
			vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
			vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
			vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
			vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
			vim.keymap.set("n", "<S-F11>", dap.step_out, { desc = "Debug: Step Out" })
			vim.keymap.set("n", "<S-F5>", dap.terminate, { desc = "Debug: Stop/Terminate" })
			vim.keymap.set("n", "<C-F5>", dap.restart, { desc = "Debug: Restart" })

			-- Primary debug controls (single letter after d)
			vim.keymap.set("n", "<leader>ds", dap.continue, { desc = "Debug: Start/Continue" })
			vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Debug: Terminate/Stop" })
			vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "Debug: Restart" })

			-- Breakpoint management (most common)
			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>dB", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Debug: Conditional Breakpoint" })

			-- Step controls (easy to remember: step + direction)
			vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Debug: Step Over" })
			vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug: Step Into" })
			vim.keymap.set("n", "<leader>du", dap.step_out, { desc = "Debug: Step Up/Out" })

			-- UI Controls
			vim.keymap.set("n", "<leader>dU", dapui.toggle, { desc = "Debug: Toggle UI" })
			vim.keymap.set("n", "<leader>dO", dapui.open, { desc = "Debug: Open UI" })
			vim.keymap.set("n", "<leader>dX", dapui.close, { desc = "Debug: Close UI" })

			-- REPL and Console
			vim.keymap.set("n", "<leader>dR", dap.repl.toggle, { desc = "Debug: Toggle REPL" })
			vim.keymap.set("n", "<leader>de", function()
				dap.repl.open()
				vim.cmd("wincmd p") -- Return focus to previous window
			end, { desc = "Debug: Open REPL" })

			-- Visual inspection (hover and preview)
			vim.keymap.set({ "n", "v" }, "<leader>dh", function()
				require("dap.ui.widgets").hover()
			end, { desc = "Debug: Hover/Inspect" })
			vim.keymap.set({ "n", "v" }, "<leader>dp", function()
				require("dap.ui.widgets").preview()
			end, { desc = "Debug: Preview Variable" })

			-- Less frequently used keymaps (dd prefix for rare functions)
			-- Advanced breakpoint management
			vim.keymap.set("n", "<leader>ddl", function()
				dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end, { desc = "Debug: Log Point" })
			vim.keymap.set("n", "<leader>ddx", dap.clear_breakpoints, { desc = "Debug: Clear All Breakpoints" })

			-- Run controls (less common)
			vim.keymap.set("n", "<leader>ddL", dap.run_last, { desc = "Debug: Run Last Configuration" })
			vim.keymap.set("n", "<leader>ddc", function()
				dap.continue()
			end, { desc = "Debug: Run/Continue" })

			-- Widget windows for detailed inspection (rarely used)
			vim.keymap.set("n", "<leader>ddf", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.frames)
			end, { desc = "Debug: Show Stack Frames" })
			vim.keymap.set("n", "<leader>dds", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.scopes)
			end, { desc = "Debug: Show Variable Scopes" })
			vim.keymap.set("n", "<leader>ddt", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.threads)
			end, { desc = "Debug: Show Threads" })

			vim.keymap.set("n", "<C-F9>", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Debug: Conditional Breakpoint" })
			vim.keymap.set("n", "<S-F9>", dap.clear_breakpoints, { desc = "Debug: Clear All Breakpoints" })

			-- Alternative comfortable keymaps for laptop users (no F-keys)
			vim.keymap.set("n", "<leader><leader>c", dap.continue, { desc = "Debug: Continue" })
			vim.keymap.set("n", "<leader><leader>n", dap.step_over, { desc = "Debug: Next (Step Over)" })
			vim.keymap.set("n", "<leader><leader>i", dap.step_into, { desc = "Debug: Into" })
			vim.keymap.set("n", "<leader><leader>o", dap.step_out, { desc = "Debug: Out" })
			vim.keymap.set("n", "<leader><leader>b", dap.toggle_breakpoint, { desc = "Debug: Breakpoint" })
		end,
		-- --- Lazy Loading Configuration ---
		-- Tell lazy.nvim to load this plugin when specific filetypes are opened
		ft = { "python", "cpp", "c" },
	},
	-- For easier debugger installation (requires mason.nvim to be installed and configured separately)
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = { "mason.nvim", "nvim-dap" },
		opts = {
			-- List of debuggers to ensure are installed via Mason for nvim-dap
			ensure_installed = { "python", "codelldb" }, -- Use "codelldb" for C++ (better than cppdbg)
			handlers = {}, -- This will use default handlers for all installed debuggers
		},
		config = function(_, opts)
			require("mason-nvim-dap").setup(opts)
		end,
	},
}
