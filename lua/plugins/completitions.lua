-- return {
-- 	{
-- 		"hrsh7th/cmp-nvim-lsp",
-- 	},
-- 	{
-- 		"L3MON4D3/LuaSnip",
-- 		dependencies = {
-- 			"saadparwaiz1/cmp_luasnip",
-- 			"rafamadriz/friendly-snippets",
-- 		},
-- 	},
-- 	{
-- 		"onsails/lspkind.nvim",
-- 	},
-- 	{
-- 		"hrsh7th/nvim-cmp",
-- 		config = function()
-- 			local cmp = require("cmp")
-- 			local lspkind = require("lspkind")
-- 			require("luasnip.loaders.from_vscode").lazy_load()
--
-- 			cmp.setup({
-- 				snippet = {
-- 					expand = function(args)
-- 						require("luasnip").lsp_expand(args.body)
-- 					end,
-- 				},
-- 				window = {
-- 					completion = cmp.config.window.bordered(),
-- 					documentation = cmp.config.window.bordered(),
-- 				},
-- 				mapping = cmp.mapping.preset.insert({
-- 					["<C-b>"] = cmp.mapping.scroll_docs(-4),
-- 					["<C-f>"] = cmp.mapping.scroll_docs(4),
-- 					["<C-Space>"] = cmp.mapping.complete(),
-- 					["<C-e>"] = cmp.mapping.abort(),
-- 					["<CR>"] = cmp.mapping.confirm({ select = true }),
-- 				}),
-- 				sources = cmp.config.sources({
-- 					{ name = "nvim_lsp" },
-- 					-- { name = "luasnip" }, -- For luasnip users.
-- 				}, {
-- 					{ name = "buffer" },
-- 				}),
--
-- 				formatting = {
-- 					format = lspkind.cmp_format({
-- 						mode = "symbol_text", -- Pokazuje ładną ikonę + tekst typu (np. Class, Method)
-- 						maxwidth = 50,
-- 						ellipsis_char = "...",
-- 						before = function(entry, vim_item)
-- 							-- Sprawdzamy, czy element podpowiedzi to "Color" (używany przez Tailwind)
-- 							if vim_item.kind == "Color" and entry.completion_item.documentation then
-- 								-- Pobieramy informację o kolorze HEX z dokumentacji serwera LSP Tailwind
-- 								local doc = entry.completion_item.documentation
-- 								local _, _, r, g, b = string.find(doc, "^#(%x%x)(%x%x)(%x%x)")
--
-- 								-- Jeśli serwer podał kolor w formacie HEX (#ffffff)
-- 								if r and g and b then
-- 									local color_group = string.format("inline_color_%s%s%s", r, g, b)
-- 									vim.api.nvim_set_hl(0, color_group, { fg = "#" .. r .. g .. b })
-- 									vim_item.kind = "■ " -- Podmieniamy ikonę na kwadracik
-- 									vim_item.kind_hl_group = color_group
-- 								end
-- 							end
-- 							return vim_item
-- 						end,
-- 					}),
-- 				},
-- 			})
-- 		end,
-- 	},
-- }

return {
	-- 1. Menedżer instalacji LSP i narzędzi
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "ts_ls", "ruff", "pyright", "html", "tailwindcss" },
			})
		end,
	},

	-- 2. Konfiguracja wbudowanego klienta LSP (Nowe API Neovim)
	{
		"neovim/nvim-lspconfig",
		dependencies = { "hrsh7th/cmp-nvim-lsp" }, -- Wymagane źródło capabilities dla nvim-cmp
		config = function()
			-- [KLUCZOWA ZMIANA]: Pobieramy capabilities i przekazujemy globalnie przez "*"
			local cmp_lsp = require("cmp_nvim_lsp")
			local capabilities = cmp_lsp.default_capabilities()

			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			-- Twoje definicje serwerów
			vim.lsp.config("lua_ls", {})
			vim.lsp.config("ts_ls", {})

			vim.lsp.config("pyright", {
				settings = {
					pyright = {
						disableOrganizeImports = true,
					},
					python = {
						analysis = {
							ignore = { "*" },
						},
						pythonPath = "venv/Scripts/python.exe",
					},
				},
			})

			vim.lsp.config("html", {
				filetypes = { "html", "htmldjango" },
			})

			vim.lsp.config("tailwindcss", {
				filetypes = { "html", "htmldjango", "javascript", "typescript", "react" },
			})

			vim.lsp.config("ruff", {})

			-- Włączenie serwerów
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("ts_ls")
			vim.lsp.enable("pyright")
			vim.lsp.enable("ruff")
			vim.lsp.enable("html")
			vim.lsp.enable("tailwindcss")

			-- Autokomenda wyłączająca hover z Ruff
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.name == "ruff" then
						client.server_capabilities.hoverProvider = false
					end
				end,
			})

			-- Skróty klawiszowe LSP
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},

	-- 3. Główny silnik autouzupełniania (nvim-cmp) oraz lspkind
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter", -- Ładuje cmp dopiero, gdy zaczniesz pisać
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- Podpowiedzi z LSP
			"hrsh7th/cmp-buffer", -- Podpowiedzi z otwartego pliku
			"hrsh7th/cmp-path", -- Podpowiedzi ścieżek do plików
			"onsails/lspkind.nvim", -- Ikony w menu podpowiedzi
		},
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")

			cmp.setup({
				-- Mapowania klawiszy dla menu podpowiedzi
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(), -- Ręczne wywołanie menu
					["<C-e>"] = cmp.mapping.abort(), -- Zamknięcie menu
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Enter potwierdza wybór
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),

				-- Deklaracja źródeł podpowiedzi (Kolejność ma znaczenie!)
				sources = cmp.config.sources({
					{ name = "nvim_lsp" }, -- Najwyższy priorytet z serwerów językowych
				}, {
					{ name = "buffer" }, -- Niższy priorytet ze słów w pliku
					{ name = "path" }, -- Ścieżki systemowe
				}),

				-- Twoja zaawansowana sekcja formatowania ikon (Tailwind + lspkind)
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
						ellipsis_char = "...",
						before = function(entry, vim_item)
							if vim_item.kind == "Color" and entry.completion_item.documentation then
								local doc = entry.completion_item.documentation
								local _, _, r, g, b = string.find(doc, "^#(%x%x)(%x%x)(%x%x)")

								if r and g and b then
									local color_group = string.format("inline_color_%s%s%s", r, g, b)
									vim.api.nvim_set_hl(0, color_group, { fg = "#" .. r .. g .. b })
									vim_item.kind = "■ "
									vim_item.kind_hl_group = color_group
								end
							end
							return vim_item
						end,
					}),
				},
			})
		end,
	},
}
