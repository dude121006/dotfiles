return {
	"williamboman/mason.nvim",
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		mason.setup()

		mason_lspconfig.setup({
			ensure_installed = {
				"clangd",
				"lua_ls",
				"emmet_ls",
				"ruff",
				"mypy",
				-- "yls_yara",
			},
			automatic_installation = true,
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier",
				"stylua",
				"eslint_d",
			},
			auto_update = false,
			run_on_start = true,
		})
	end,
}
