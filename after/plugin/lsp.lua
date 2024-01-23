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

lspconfig.clangd.setup {}

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

	-- call default_keymaps last to not overwrite anything above
	lsp_zero.default_keymaps({ buffer = bufnr })
end)
