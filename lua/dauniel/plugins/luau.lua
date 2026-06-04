return {
	{
		"lopi-py/luau-lsp.nvim",
		ft = { "luau" },
		opts = {
			platform = {
				type = "roblox",
			},

			types = {
				roblox_security_level = "PluginSecurity",
			},

			sourcemap = {
				enabled = true,
				autogenerate = true,
				rojo_project_file = "default.project.json", -- zmień jeśli masz inną nazwę
				sourcemap_file = "sourcemap.json",
				include_non_scripts = true,
			},

			plugin = {
				enabled = false, -- ustaw true tylko jeśli używasz Studio Companion Plugin
				port = 3667,
			},

			server = {
				path = "luau-lsp", -- Mason powinien dodać to do PATH
			},
		},
	},
}
