return {
	"vyfor/cord.nvim",
	config = function()
		require("cord").setup({
			editor = {
				client = "vim",
				tooltip = "nvim",
			},
			display = {
				theme = "classic",
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

