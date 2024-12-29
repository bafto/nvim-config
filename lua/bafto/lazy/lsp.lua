return {
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		lazy = true,
		config = false,
		init = function()
			-- Disable automatic setup, we are doing it manually
			vim.g.lsp_zero_extend_cmp = 0
			vim.g.lsp_zero_extend_lspconfig = 0
		end,
	},
	{
		'williamboman/mason.nvim',
		lazy = false,
		config = true,
	},

	-- Autocompletion
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/nvim-cmp',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-nvim-lua',
			'rafamadriz/friendly-snippets',
			'saadparwaiz1/cmp_luasnip',
			'L3MON4D3/LuaSnip',
		},
		event = 'InsertEnter',
		config = function()
			local lsp_zero = require('lsp-zero')
			lsp_zero.extend_cmp()

			local cmp = require('cmp')
			local cmp_select = { behavior = cmp.SelectBehavior.Select }

			cmp.setup({
				sources = {
					{ name = 'path' },
					{ name = 'nvim_lsp' },
					{ name = 'nvim_lua' },
					{ name = 'luasnip', keyword_length = 2 },
					{ name = 'buffer',  keyword_length = 3 },
				},
				formatting = lsp_zero.cmp_format({}),
				mapping = cmp.mapping.preset.insert({
					['<C-K>'] = cmp.mapping.select_prev_item(cmp_select),
					['<C-J>'] = cmp.mapping.select_next_item(cmp_select),
					['<C-L>'] = cmp.mapping.confirm({ select = true }),
					['<C-Space>'] = cmp.mapping.complete(),
				}),
			})
		end,
	},

	-- LSP
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'williamboman/mason-lspconfig.nvim',
			'ray-x/lsp_signature.nvim',
			'lukas-reineke/lsp-format.nvim',
			'stevearc/conform.nvim',
			'mfussenegger/nvim-jdtls',
		},
		event = { 'BufReadPre', 'BufNewFile' },
		cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
		config = function()
			local util = require('bafto.util')
			local lsp_zero = require('lsp-zero')

			require('mason').setup({})
			require('mason-lspconfig').setup({
				ensure_installed = {
					'ts_ls',
					'eslint',
					'gopls',
					'clangd',
					'cmake',
					'dockerls',
					'docker_compose_language_service',
					'html',
					'jdtls',
					'jedi_language_server',
					'sqls',
					'lua_ls',
					'lemminx',
					'terraformls',
				},
				handlers = {
					-- lsp_zero.default_setup,
					lua_ls = function()
						local lua_opts = lsp_zero.nvim_lua_ls()
						require('lspconfig').lua_ls.setup(lua_opts)
					end,
				}
			})
			require('mason-lspconfig').setup_handlers({
				['jdtls'] = function() end
			})

			local lspconfig = require('lspconfig')

			lspconfig.metals.setup {}

			lspconfig.gopls.setup {
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
						},
						staticcheck = true,
						gofumpt = true,
					},
				},
			}

			local clangd_capabilities = vim.lsp.protocol.make_client_capabilities()
			clangd_capabilities.offsetEncoding = 'utf-8'
			lspconfig.clangd.setup {
				capabilities = clangd_capabilities,
				cmd = {
					'clangd',
					'--background-index',
					'-j=2',
					'--clang-tidy',
					'--enable-config',
					'--all-scopes-completion',
					'--header-insertion=never',
					'--completion-style=detailed',
				},
				root_dir = lspconfig.util.root_pattern('compile_commands.json', '.git', '.clangd', '.clang-format')
			}


			lspconfig.html.setup {
				filetypes = { "html", "templ", "gohtml" },
			}
			lspconfig.ts_ls.setup {}
			lspconfig.eslint.setup {}
			lspconfig.cmake.setup {}
			lspconfig.dockerls.setup {}
			lspconfig.docker_compose_language_service.setup {}
			lspconfig.jedi_language_server.setup {}
			lspconfig.terraformls.setup {}

			lspconfig.lemminx.setup {
				settings = {
					xml = {
						format = {
							enabled = false,
						}
					}
				}
			}

			-- DDP setup
			vim.filetype.add({
				extension = {
					ddp = 'ddp',
				},
			})

			local lspconfig_configs = require('lspconfig.configs')
			if not lspconfig_configs.ddpls then
				lspconfig_configs.ddpls = {
					default_config = {
						name = 'DDPLS',
						cmd = { 'DDPLS' },
						filetypes = { 'ddp' },
						root_dir = lspconfig.util.root_pattern('.git') or vim.fn.getcwd(),
					},
				}
			end

			lspconfig.ddpls.setup {}

			vim.api.nvim_create_augroup("AutoImports", {})

			vim.api.nvim_create_autocmd(
				"BufWritePost",
				{
					group = "AutoImports",
					pattern = "*.go",
					callback = function()
						local params = vim.lsp.util.make_range_params()
						params.context = { only = { "source.organizeImports" } }
						local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
						for cid, res in pairs(result or {}) do
							for _, r in pairs(res.result or {}) do
								if r.edit then
									local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-8"
									vim.lsp.util.apply_workspace_edit(r.edit, enc)
								end
							end
						end
					end
				}
			)

			local lsp_format = require('lsp-format')
			local format_options = {
				java = {
					exclude = { 'jdtls' },
					tab_width = 2,
				},
				sql = {
					exclude = { 'sqls' },
				},
				xml = {
					exclude = { 'lemminx' }
				}
			}
			lsp_format.setup(format_options)

			local conform = require('conform')
			conform.setup {
				formatters_by_ft = {
					java = { 'google-java-format' },
				},
				format_after_save = {
					lsp_fallback = false,
				},
			}

			local function on_attach(client, bufnr)
				-- format using the language server
				if client.supports_method('textDocument/formatting') then
					lsp_format.on_attach(client)
				end

				-- show signature help
				require('lsp_signature').on_attach({
					hint_prefix = "",
					bind = true,
					doc_lines = 0,
				})

				-- use telescope for some lsp stuff
				local telescope = require('telescope.builtin')

				vim.keymap.set('n', 'gr', telescope.lsp_references, { desc = 'goto references' })
				vim.keymap.set('n', 'gd', telescope.lsp_definitions, { desc = 'goto definition' })
				vim.keymap.set('n', 'gi', telescope.lsp_implementations, { desc = 'goto implementation' })
				vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, { desc = 'goto type definition' })
				vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, { desc = 'display signature' })
				vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { desc = 'rename' })
				vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = 'get diagnostics' })
				vim.keymap.set('n', '<leader>gn', vim.diagnostic.goto_next, { desc = 'goto next diagnostic' })
				vim.keymap.set('n', '<leader>gN', vim.diagnostic.goto_next, { desc = 'goto next diagnostic' })

				-- list workspace folders
				vim.keymap.set('n', '<leader>lwf', function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, { desc = 'list workspace folders' })
				vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'hover' })

				-- quickfix
				vim.keymap.set('n', '<leader>qf', function()
					vim.lsp.buf.code_action({
						filter = function(a) return a.isPreferred end,
						apply = true,
					})
				end, { desc = 'quickfix' })

				-- <C-f> formats the current buffer
				vim.keymap.set("n", "<C-f>", function()
					lsp_format.format({ buf = bufnr })
					if client.name == 'jdtls' then
						conform.format({ async = true, bufnr = bufnr })
					end
				end, { desc = "Format async using LSP" })

				-- <leader>hr highlights references
				local highlight_supported = client.supports_method('textDocument/documentHighlight')
				vim.keymap.set('n', '<leader>dh', function()
					if highlight_supported then
						vim.lsp.buf.document_highlight()
					else
						print('Document Highlight not supported')
					end
				end, { desc = 'highlight references' })
			end

			local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "java" },
				callback = function()
					require('jdtls').start_or_attach({
						cmd = {
							util.is_windows() and "jdtls.cmd" or "jdtls",
							"-configuration", vim.env.HOME .. "/.cache/jdtls/config",
							"-data", vim.env.HOME .. "/.cache/jdtls/workspace/" .. project_name,
							"--add-modules=ALL-SYSTEM",
							"--add-opens java.base/java.util=ALL-UNNAMED",
							"--add-opens java.base/java.lang=ALL-UNNAMED",
							"-Xmx2g",
						},
						settings = {
							java = {
								signatureHelp = { enabled = true },
								contentProvider = { preferred = "fernflower" },
								foramt = { enabled = false },
							},
						},
						root_dir = vim.fs.root(0, { '.git', 'mvnw', 'gradlew' }),
					})
				end
			})

			-- only call on_attach ones, as the last one will overwrite the previous ones
			lsp_zero.on_attach(on_attach)

			vim.api.nvim_create_user_command('StopLsp', function()
				for i, server in ipairs(vim.lsp.get_clients()) do
					vim.lsp.get_client_by_id(server.id).stop()
				end
			end, { desc = 'stops all language servers' })
		end
	},
}
