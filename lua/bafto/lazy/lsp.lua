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
				formatting = lsp_zero.cmp_format(),
				mapping = cmp.mapping.preset.insert({
					['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
					['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
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
		},
		event = { 'BufReadPre', 'BufNewFile' },
		cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
		config = function()
			local lsp_zero = require('lsp-zero')

			require('mason').setup({})
			require('mason-lspconfig').setup({
				ensure_installed = { 'tsserver', 'eslint', 'gopls', 'clangd', 'cmake', 'dockerls', 'html', 'jdtls', 'pyright', 'sqls', 'lua_ls' },
				handlers = {
					lsp_zero.default_setup,
					lua_ls = function()
						local lua_opts = lsp_zero.nvim_lua_ls()
						require('lspconfig').lua_ls.setup(lua_opts)
					end,
				}
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

			lspconfig.clangd.setup {
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

			lspconfig.html.setup {}
			lspconfig.tsserver.setup {}
			lspconfig.eslint.setup {}

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

			-- only call on_attach ones, as the last one will overwrite the previous ones
			lsp_zero.on_attach(function(client, bufnr)
				-- format using the language server
				if client.supports_method('textDocument/formatting') then
					require('lsp-format').on_attach(client)
				end

				-- use telescope for some lsp stuff
				local telescope = require('telescope.builtin')

				vim.keymap.set('n', 'gr', telescope.lsp_references)
				vim.keymap.set('n', 'gd', telescope.lsp_definitions)
				vim.keymap.set('n', 'gi', telescope.lsp_implementations)
				vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)
				vim.keymap.set('n', '<leader>lwf', function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end)
				vim.keymap.set('n', 'K', vim.lsp.buf.hover)
				vim.keymap.set('n', '<leader>qf', function()
					vim.lsp.buf.code_action({
						filter = function(a) return a.isPreferred end,
						apply = true,
					})
				end)

				-- call default_keymaps last to not overwrite anything above
				lsp_zero.default_keymaps({ buffer = bufnr })
			end)
		end
	},
}