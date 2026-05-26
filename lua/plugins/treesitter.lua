return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local scoop_gcc = vim.env.USERPROFILE .. "\\scoop\\apps\\gcc\\current\\bin"
		vim.env.PATH = scoop_gcc .. ";" .. vim.env.PATH

		require("nvim-treesitter.install").compilers = { "gcc" }

		vim.env.CC = "gcc"
	end,
}
