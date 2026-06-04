return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"stevearc/conform.nvim",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
	},

	config = function()
		-- require("conform").setup({
		-- 	formatters_by_ft = {},
		-- })
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)

		local function is_rojo_project(path)
			return vim.fs.root(path or 0, function(name)
				return name:match(".+%.project%.json$")
			end) ~= nil
		end

		vim.filetype.add({
			extension = {
				luau = "luau",

				lua = function(path)
					if path:match("%.nvim%.lua$") then
						return "lua"
					end

					if is_rojo_project(path) then
						return "luau"
					end

					return "lua"
				end,
			},
		})

		require("fidget").setup({})
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"luau_lsp",
				"rust_analyzer",
				"gopls",
				"vtsls",
				"tailwindcss",
				"html",
				"terraformls",
				"tflint",
				"dockerls",
				"docker_compose_language_service",
				"helm_ls",
				"yamlls",
			},
			automatic_enable = {
				exclude = { "luau_lsp" },
			},
			handlers = {
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,

				["html"] = function()
					require("lspconfig").html.setup({
						capabilities = capabilities,
						filetypes = { "html", "htmldjango" },
					})
				end,

				zls = function()
					local lspconfig = require("lspconfig")
					lspconfig.zls.setup({
						root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
						settings = {
							zls = {
								enable_inlay_hints = true,
								enable_snippets = true,
								warn_style = true,
							},
						},
					})
					vim.g.zig_fmt_parse_errors = 0
					vim.g.zig_fmt_autosave = 0
				end,

				["lua_ls"] = function()
					if is_rojo_project() then
						return
					end

					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								runtime = { version = "LuaJIT" },
								diagnostics = { globals = { "vim" } },
								workspace = {
									library = vim.api.nvim_get_runtime_file("", true),
									checkThirdParty = false,
								},
								format = {
									enable = true,
									defaultConfig = {
										indent_style = "space",
										indent_size = "2",
									},
								},
							},
						},
					})
				end,

				["tailwindcss"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.tailwindcss.setup({
						capabilities = capabilities,
						filetypes = {
							"html",
							"css",
							"scss",
							"javascript",
							"javascriptreact",
							"typescript",
							"typescriptreact",
							"vue",
							"svelte",
							"heex",
							"htmldjango",
						},
					})
				end,

				["terraformls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.terraformls.setup({
						capabilities = capabilities,
						filetypes = { "terraform", "terraform-vars", "tf" },
					})
				end,

				["tflint"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.tflint.setup({
						capabilities = capabilities,
					})
				end,

				["dockerls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.dockerls.setup({
						capabilities = capabilities,
					})
				end,

				["docker_compose_language_service"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.docker_compose_language_service.setup({
						capabilities = capabilities,
						filetypes = { "yaml.docker-compose" },
						-- Rozpoznaje docker-compose*.yml automatycznie
						root_dir = lspconfig.util.root_pattern(
							"docker-compose.yml",
							"docker-compose.yaml",
							"compose.yml",
							"compose.yaml"
						),
					})
				end,

				["helm_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.helm_ls.setup({
						capabilities = capabilities,
						settings = {
							["helm-ls"] = {
								yamlls = {
									path = "yaml-language-server",
								},
							},
						},
					})
				end,

				["yamlls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.yamlls.setup({
						capabilities = capabilities,
						settings = {
							yaml = {
								schemas = {
									["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
									["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.{yml,yaml}",
									["https://json.schemastore.org/kustomization.json"] = "kustomization.{yml,yaml}",
									["https://json.schemastore.org/chart.json"] = "Chart.{yml,yaml}",
									["https://json.schemastore.org/taskfile.json"] = "Taskfile*.{yml,yaml}",
								},
								validate = true,
								completion = true,
								hover = true,
							},
						},
					})
				end,
			},
		})

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- For luasnip users.
			}, {
				{ name = "buffer" },
			}),
		})

		vim.diagnostic.config({
			-- update_in_insert = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})
	end,
}
