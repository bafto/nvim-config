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
			'powershell-editor-services'
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

		vim.lsp.config['powershell-editor-services'] = {
			filetypes = { 'ps1' }
		}

		local util = require('bafto.util')
		local java_format_xml_path = os.getenv('JAVA_FORMAT_OPTIONS')
		local java_home_21 = os.getenv('JAVA_HOME_21')
		local java_exe_path = java_home_21 == nil and 'java' or java_home_21 .. '\\bin\\java'
		local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
		vim.lsp.config['jdtls'] = {
			cmd = {
				util.is_windows() and "jdtls.cmd" or "jdtls",
				"--java-executable", java_exe_path,
				"-configuration", vim.env.HOME .. "/.cache/jdtls/config",
				"-data", vim.env.HOME .. "/.cache/jdtls/workspace/" .. project_name,
				"--add-modules=ALL-SYSTEM",
				"--add-opens java.base/java.util=ALL-UNNAMED",
				"--add-opens java.base/java.lang=ALL-UNNAMED",
				"-Xmx2g",
			},
			settings = {
				java = {
					format = {
						enabled = false,
						comments = { enabled = true },
						insertSpaces = true,
						tabSize = 3,
						settings = {
							url = java_format_xml_path,
							profile = 'dsCodeFormatter',
						},
					},
					signatureHelp = { enabled = true },
					contentProvider = { preferred = "fernflower" },
				},
			},
			root_dir = vim.fs.root(0, { '.git', 'mvnw', 'gradlew' }),
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
						if client:supports_method("textDocument/codeAction") then
							local function apply_code_action(action_type)
								local ctx = { only = action_type, diagnostics = {} }
								local actions = vim.lsp.buf.code_action({ context = ctx, apply = true, return_actions = true })

								-- only apply if code action is available
								if actions and #actions > 0 then
									vim.lsp.buf.code_action({ context = ctx, apply = true })
								end
							end
							apply_code_action({ "source.organizeImports" })
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
