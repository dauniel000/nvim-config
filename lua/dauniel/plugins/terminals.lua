return {
	"akinsho/toggleterm.nvim",
	version = "*",
	keys = {
		{ "<A-1>", "<cmd>1ToggleTerm<cr>", desc = "Terminal 1", mode = { "n", "t" } },
		{ "<A-2>", "<cmd>2ToggleTerm<cr>", desc = "Terminal 2", mode = { "n", "t" } },
		{ "<A-3>", "<cmd>3ToggleTerm<cr>", desc = "Terminal 3", mode = { "n", "t" } },
	},
	config = function()
		require("toggleterm").setup({
			shell = "cmd.exe",
			direction = "float",
			hide_numbers = true,
			shade_terminals = true,
			close_on_exit = true,
			float_opts = {
				border = "curved",
				winblend = 3,
			},
		})

		function _G.set_terminal_keymaps()
			local opts = { buffer = 0 }
			vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)
			vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
			vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
			vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
			vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
		end

		vim.api.nvim_create_autocmd("TermOpen", {
			pattern = "term://*",
			callback = function()
				_G.set_terminal_keymaps()
			end,
		})
	end,
}
