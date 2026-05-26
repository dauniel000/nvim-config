-- return {
-- 	{
-- 		"windwp/nvim-autopairs",
-- 		event = "InsertEnter",
-- 		config = function()
-- 			require("nvim-autopairs").setup({})
-- 		end,
-- 	},
-- 	{
-- 		"windwp/nvim-ts-autotag",
-- 		event = { "BufReadPre", "BufNewFile" },
-- 		config = function()
-- 			require("nvim-ts-autotag").setup({
-- 				opts = {
-- 					enable_close = true, -- Automatyczne zamykanie tagów (np. <div>)
-- 					enable_rename = true, -- Automatyczna zmiana sparowanego tagu przy edycji
-- 					enable_close_on_slash = false, -- Domykanie przy wpisaniu "/"
-- 				},
-- 				-- Wymuszenie działania autotagu HTML również w szablonach Jinja/Django
-- 				per_filetype = {
-- 					["html"] = { enable_close = true },
-- 					["htmldjango"] = { enable_close = true },
-- 					["jinja"] = { enable_close = true },
-- 				},
-- 			})
-- 		end,
-- 	},
-- }
return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			-- Minimalny setup autopairs: działa dla standardowego html,
			-- ale nie wchodzi w paradę autotagom
			require("nvim-autopairs").setup({
				check_ts = true,
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "InsertEnter",
		config = function()
			-- KLUCZOWY TRICK: Rejestrujemy język htmldjango jako alias dla parsera html
			-- Od teraz autotagi traktują szablony Django dokładnie jak zwykły html!
			vim.treesitter.language.register("html", "htmldjango")

			require("nvim-ts-autotag").setup({
				opts = {
					enable_close = true,
					enable_rename = true,
					enable_close_on_slash = false,
				},
			})
		end,
	},
}
