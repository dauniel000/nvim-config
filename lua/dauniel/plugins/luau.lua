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
				generator_cmd = { "rojo", "sourcemap", "default.project.json", "--output", "sourcemap.json" },
				rojo_project_file = "default.project.json",
				sourcemap_file = "sourcemap.json",
				include_non_scripts = true,
			},

			plugin = {
				enabled = false,
				port = 3667,
			},

			server = {
				-- path = os.getenv("USERPROFILE") .. "\\.rokit\\bin\\luau-lsp.exe",  -- for window
			},
		},
	},
}
