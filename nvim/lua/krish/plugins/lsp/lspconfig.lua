return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"folke/neodev.nvim",
	},
	config = function()
		-- Neovim Lua LSP helper
		require("neodev").setup()

		-- Capabilities for autocompletion
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Mason setup
		require("mason").setup()

		-- Mason LSPConfig setup
		require("mason-lspconfig").setup({
			ensure_installed = {
				"clangd",
				"lua_ls",
				"emmet_ls",
				"pyright",
				-- "yls_yara", -- Uncomment if you want this
			},
			on_setup = function(server_name)
				local lspconfig = require("lspconfig")

				if server_name == "clangd" then
					lspconfig.clangd.setup({
						capabilities = capabilities,
						cmd = {
							"clangd",
							"--background-index",
							"--clang-tidy",
							"--completion-style=detailed",
							"--header-insertion=iwyu",
						},
						filetypes = { "c", "cpp", "objc", "objcpp" },
						root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
					})
				elseif server_name == "pyright" then
					lspconfig.pyright.setup({
						capabilities = capabilities,
						filetypes = { "python" },
						flags = {
							debounce_text_changes = 150,
						},
					})
				else
					lspconfig[server_name].setup({
						capabilities = capabilities,
					})
				end
			end,
		})

		-- LspAttach autocommand for keymaps
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				local encoding = client and client.offset_encoding or "utf-16"

				local opts = { buffer = ev.buf, silent = true }

				opts.desc = "Show LSP references"
				vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

				opts.desc = "Go to declaration"
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP definitions"
				vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

				opts.desc = "Show LSP implementations"
				vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Show LSP type definitions"
				vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				opts.desc = "See available code actions"
				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				opts.desc = "Smart rename"
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				vim.keymap.set("n", "<leader>Db", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Show line diagnostics"
				vim.keymap.set("n", "<leader>Dl", vim.diagnostic.open_float, opts)

				opts.desc = "Go to previous diagnostic"
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

				opts.desc = "Go to next diagnostic"
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

				opts.desc = "Show documentation for what is under cursor"
				vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)

				opts.desc = "Show signature of what is under cursor"
				vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, opts)

				opts.desc = "Restart LSP"
				vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
			end,
		})
	end,
}
