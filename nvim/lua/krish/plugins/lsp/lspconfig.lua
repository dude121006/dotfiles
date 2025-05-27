return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		-- Import lspconfig plugin
		local lspconfig = require("lspconfig")

		-- Import mason_lspconfig plugin
		local mason_lspconfig = require("mason-lspconfig")

		-- Import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness

		-- Add the custom handler for documentation formatting
		-- Custom handler for clangd documentation
		local function clean_clangd_doc(content)
			if not content then
				return content
			end

			-- Print content for debugging (remove later)
			-- print("Original content:", content)

			-- Remove comment markers (try different variations)
			content = content:gsub("///", "")
			content = content:gsub("//", "")

			-- Format params - trying different patterns
			content = content:gsub("@param%s+(%S+)%s*%->%s*", "**%1**: ")
			content = content:gsub("@param%s+(%S+)%s+", "**%1**: ")

			-- Format return values
			content = content:gsub("@return%s*%->%s*", "**Returns**: ")
			content = content:gsub("@return%s+", "**Returns**: ")

			-- Remove any "// In" comments
			content = content:gsub("// In [^\n]+", "")

			-- Clean up the "provided by" line
			content = content:gsub("provided by `[^`]+`", "")

			return content
		end
		--
		-- vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
		-- 	local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
		-- 	local clean_lines = vim.tbl_filter(function(line)
		-- 		return not line:match("^//")
		-- 	end, markdown_lines)
		--
		-- 	vim.lsp.util.open_floating_preview(clean_lines, "markdown", config)
		-- end

		-- Create autocommand for LSP Attach
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }

				-- Set keybinds for LSP functionality
				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "gh", vim.lsp.buf.hover, opts)

				opts.desc = "Show signature of what is under cursor"
				keymap.set("n", "gK", vim.lsp.buf.signature_help, opts)

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
			end,
		})

		-- Used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change Diagnostic symbols in the sign column (gutter)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- Mason setup handlers for LSP servers
		mason_lspconfig.setup_handlers({
			-- Default handler for installed servers
			function(server_name)
				if server_name == "jdtls" then
					return -- Prevent jdtls from being set up twice
				end
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,

			["clangd"] = function()
				lspconfig["clangd"].setup({
					capabilities = capabilities,
					cmd = {
						"clangd",
						"--header-insertion=never",
						"--completion-style=detailed",
						"--function-arg-placeholders=false",
						"--fallback-style=llvm",
						"--enable-config", -- Enable clangd config file
						"--all-scopes-completion", -- Complete across all scopes
						"--background-index", -- Index project in background
						"--pch-storage=memory", -- Store PCH in memory
					},
					init_options = {
						usePlaceholders = true,
						completeUnimported = true,
						clangdFileStatus = true,
						documentationFormat = { "markdown", "plaintext" },
					},
					on_attach = function(client, bufnr)
						-- Your existing on_attach function content if any
					end,
				})
			end,

			["tsserver"] = function()
				lspconfig.tsserver.setup({
					capabilities = capabilities,
					on_attach = function(client, bufnr)
						client.server_capabilities.documentFormattingProvider = false
					end,
				})
			end,

			["svelte"] = function()
				-- Configure svelte server
				lspconfig["svelte"].setup({
					capabilities = capabilities,
					on_attach = function(client, bufnr)
						vim.api.nvim_create_autocmd("BufWritePost", {
							pattern = { "*.js", "*.ts" },
							callback = function(ctx)
								client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
							end,
						})
					end,
				})
			end,

			["graphql"] = function()
				-- Configure GraphQL language server
				lspconfig["graphql"].setup({
					capabilities = capabilities,
					filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
				})
			end,
			-- In your lspconfig setup file
			["emmet_ls"] = function()
				-- Configure Emmet language server
				lspconfig["emmet_ls"].setup({
					capabilities = _G.capabilities, -- Use the capabilities we created in cmp setup
					filetypes = {
						"html",
						"typescriptreact",
						"javascriptreact",
						"css",
						"sass",
						"scss",
						"less",
						"svelte",
					},
					init_options = {
						html = {
							options = {
								-- For VSCode-like behavior
								["bem.enabled"] = true,
							},
						},
					},
				})
			end,
			["lua_ls"] = function()
				-- Configure Lua language server
				lspconfig["lua_ls"].setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				})
			end,

			-- function(tsserver)
			-- 	lspconfig[tsserver].setup({
			-- 		capabilities = capabilities,
			-- 	})
			-- end,
			-- ["yamlls"] = function()
			-- 	-- Configure YAML language server for .yara files
			-- 	lspconfig["yamlls"].setup({
			-- 		capabilities = capabilities,
			-- 		filetypes = { "yaml", "yara" }, -- Add "yara" here
			-- 		settings = {
			-- 			yaml = {
			-- 				schemas = {
			-- 					["https://json.schemastore.org/yaml"] = "*.yara",
			-- 				},
			-- 				validate = true,
			-- 			},
			-- 		},
			-- 	})
			-- end,
			-- ["yls_yara"] = function()
			-- 	lspconfig["yls_yara"].setup({
			-- 		capabilities = capabilities,
			-- 		filetypes = { "yara" },
			-- 	})
			-- end,
		})
	end,
}
