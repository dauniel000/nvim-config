return {

	"rcarriga/nvim-notify",
	config = function()
		local notify = require("notify")
		notify.setup({
			timeout = 3000,
			stages = "fade_in_slide_out",
			fps = 75,
		})

		vim.notify = notify

		-- local posturaTimer = vim.uv.new_timer()
		-- local czasPostura = 0.5 * 60 * 1000 -- first value in minutes
		--
		-- posturaTimer:start(
		-- 	czasPostura,
		-- 	czasPostura,
		-- 	vim.schedule_wrap(function()
		-- 		vim.notify("Wyprostuj się!", "warn", { title = "Postura", icon = "🪑" })
		-- 	end)
		-- )
	end,
}
