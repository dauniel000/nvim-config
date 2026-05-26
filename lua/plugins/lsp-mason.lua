return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "ts_ls", "ruff", "pyright", "html", "tailwindcss" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			vim.lsp.config("lua_ls", {})
			vim.lsp.config("ts_ls", {})

			vim.lsp.config("pyright", {
				settings = {
					pyright = {
						disableOrganizeImports = true,
					},
					python = {
						analysis = {
							ignore = { "*" },
						},
						pythonPath = "venv/Scripts/python.exe",
					},
				},
			})

			vim.lsp.config("html", {
				capabilities = capabilities,
				filetypes = { "html", "htmldjango" },
			})

			vim.lsp.config("tailwindcss", {
				filetypes = { "html", "htmldjango", "javascript", "typescript", "react" },
			})

			vim.lsp.config("ruff", {})

			vim.lsp.enable("lua_ls")
			vim.lsp.enable("ts_ls")
			vim.lsp.enable("pyright")
			vim.lsp.enable("ruff")
			vim.lsp.enable("html")
			vim.lsp.enable("emmet_language_server")
			vim.lsp.enable("tailwindcss")

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.name == "ruff" then
						client.server_capabilities.hoverProvider = false
					end
				end,
			})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
