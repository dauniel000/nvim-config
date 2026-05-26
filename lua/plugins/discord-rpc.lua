-- return {
-- 	"andweeb/presence.nvim",
-- 	config = function()
-- 		local presence = require("presence")
-- 		presence.setup({
-- 			auto_update = true,
-- 			show_time = true,
--
-- 			-- Główne zdjęcie ustawione na neovim
-- 			main_image = "neovim",
--
-- 			-- Tekst wyświetlany po najechaniu na DUŻE zdjęcie (logo Neovim)
-- 			neovim_image_text = "Kod Edytor :)",
--
-- 			-- RĘCZNE NADPISANIE TEKSTÓW DLA MAŁEJ IKONKI (Zamiast "neo-tree filesystem")
-- 			file_assets = {
-- 				-- format: ["nazwa_pliku_lub_rozszerzenie"] = { "nazwa", "ikona", "tekst_po_najechaniu" }
-- 				["neo-tree"] = { "File Tree", "folder", "Aiaiaiaiaiai" },
-- 				["neo-tree filesystem"] = { "File Tree", "folder", "Aiaiaiaiaiai" },
-- 			},
--
-- 			-- Bezpieczne teksty po angielsku bez ujawniania nazw (%s)
-- 			editing_text = "Editing code",
-- 			file_explorer_text = "Browsing files",
-- 			git_commit_text = "Committing changes",
-- 			plugin_manager_text = "Managing plugins",
-- 			reading_text = "Reading documentation",
-- 			workspace_text = "Working on a project",
-- 			line_number_text = "Line %s of %s",
-- 		})
-- 	end,
-- }
return {
	"vyfor/cord.nvim",
	config = function()
		require("cord").setup({
			editor = {
				client = "vim",
				tooltip = "nvim",
			},
			display = {
				theme = "minecraft",
				flavor = "light",
			},
			idle = {
				enabled = false,
			},
			text = {
				default = "Using Neovim",
				file_browser = "Browsing files",
				editing = "Editing a file",
				viewing = "Viewing a file",
				debug = "Debugging project",
				test = "Testing project",
				workspace = "",
				notes = false,
				vcs = false,
				lsp = false,
				plugin_manager = false,
			},
			buttons = {
				{
					label = "Wieża Babel",
					url = "https://www.youtube.com/watch?v=SuQhkNyOQro",
				},
			},
		})
	end,
}
