return {
	"brenoprata10/nvim-highlight-colors",
	config = function()
		vim.opt.termguicolors = true

		require("nvim-highlight-colors").setup({
			render = "background",

			enable_tailwind = true,

			virtual_symbol_position = "eol",
		})
	end,
}
