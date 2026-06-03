return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			format_on_save = {
				timeout_ms = 5000,
				lsp_format = "fallback",
			},
			formatters_by_ft = {
				c = { "clang-format" },
				cpp = { "clang-format" },
				lua = { "stylua" },
				go = { "gofmt" },
				odin = { "odinfmt" },
				html = { "prettier" },
				htmldjango = { "prettier" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				elixir = { "mix" },
				python = { "ruff_format", "ruff_organize_imports" },
			},
			formatters = {
				["clang-format"] = {
					prepend_args = { "-style=file", "-fallback-style=LLVM" },
				},
				["prettier"] = {
					htmldjango = "html",
				},
			},
		})

		vim.keymap.set("n", "<leader>f", function()
			require("conform").format({ bufnr = 0 })
		end)
	end,
}
