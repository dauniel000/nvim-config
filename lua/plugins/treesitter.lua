-- return {
-- 	"nvim-treesitter/nvim-treesitter",
-- 	lazy = false,
-- 	build = ":TSUpdate",
-- 	config = function()
-- 		require("nvim-treesitter.install").compilers = { "clang", "gcc" }
--
-- 		local config = require("nvim-treesitter.config")
-- 		config.setup({
-- 			autoinstall = true,
-- 			highlight = { enable = true },
-- 			indent = { enable = true },
-- 		})
-- 	end,
-- }
return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		-- 1. Automatyczne wykrycie ścieżki do GCC zainstalowanego przez Scoop
		local scoop_gcc = vim.env.USERPROFILE .. "\\scoop\\apps\\gcc\\current\\bin"
		vim.env.PATH = scoop_gcc .. ";" .. vim.env.PATH

		-- 2. Wymuszenie użycia kompilatora GCC i zablokowanie szukania cl.exe
		require("nvim-treesitter.install").compilers = { "gcc" }

		-- 3. Globalne ustawienie zmiennej kompilatora C dla systemu
		vim.env.CC = "gcc"
	end,
}
