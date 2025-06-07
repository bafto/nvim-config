return {
	"neovim/nvim-lspconfig",

	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
	},

	config = function()
		-- require('mason-lspconfig').setup {
		-- 	automatic_enable = false
		-- }

		require('mason').setup {}
		require('mason-lspconfig').setup {}
		vim.lsp.enable({
			'lua_ls',
			'gopls',
			'jdtls',
			'clangd',
			'dartls',
			'pyright',
			'vue_ls',
			'cmake',
			'docker_compose_language_service',
			'dockerls',
			'eslint',
			'html',
			'lemminx',
			'rust_analyzer',
			'sqls',
			'staticcheck',
			'terraformls',
		})

		vim.lsp.config['gopls'] = {
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

		vim.lsp.config['clangd'] = {
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
			root_markers = { '.clangd', '.clang-format', 'compile_commands.json', '.git' }
		}

		vim.lsp.config['html'] = {
			filetypes = { "html", "templ", "gohtml" },
		}

		vim.lsp.config['vue_ls'] = {
			filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
			init_options = {
				vue = {
					-- disable hybrid mode
					hybridMode = false,
				},
			},
		}

		vim.lsp.config['dartls'] = {
			cmd = { 'dart', 'language-server', '--protocol=lsp' },
			filetypes = { 'dart' },
		}

		vim.api.nvim_create_autocmd("LspAttach", {
			desc = "LSP actions",
			callback = function(args)
				local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
				if not client then
					return
				end

				-- Format and autoimport on Save
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = args.buf,
					callback = function()
						if client:supports_method("textDocument/formatting") then
							vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
						end
					end,
				})

				-- Lsp Keymaps
				local nmap = function(keys, func, desc)
					if desc then
						desc = "LSP: " .. desc
					end
					vim.keymap.set("n", keys, func, { buffer = args.buf, noremap = true, silent = true, desc = desc })
				end

				local telescope = require('telescope.builtin')

				nmap("K", vim.lsp.buf.hover, "Open hover")
				nmap("<leader>r", vim.lsp.buf.rename, "Rename")
				nmap("<leader>dh", vim.lsp.buf.document_highlight, "Rename")
				nmap("gt", vim.lsp.buf.type_definition, "Goto type definition")
				nmap("gr", telescope.lsp_references, "References")
				nmap("gd", telescope.lsp_definitions, "Goto definition")
				nmap("gi", telescope.lsp_implementations, "Goto implementation")

				-- Diagnostic
				nmap("gn", function()
					vim.diagnostic.jump({ count = 1, float = true })
				end, "Goto next diagnostic")
				nmap("gN", function()
					vim.diagnostic.jump({ count = -1, float = true })
				end, "Goto prev diagnostic")
				nmap("gl", vim.diagnostic.open_float, "Open diagnostic float")
				nmap("gs", vim.lsp.buf.signature_help, "Signature Help")

				nmap("<C-F>", vim.lsp.buf.format, "Format current buffer")
			end
		})
	end
}
