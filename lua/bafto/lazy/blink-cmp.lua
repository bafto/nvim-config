return {
	'saghen/blink.cmp',
	dependencies = { 'rafamadriz/friendly-snippets' },

	-- use a release tag to download pre-built binaries
	version = '1.3.1',

	opts = {
		keymap = {
			preset = 'none',
			["<C-K>"] = { "select_prev", "snippet_backward", "fallback" },
			["<C-J>"] = { "select_next", "snippet_forward", "fallback" },
			["<C-L>"] = { "accept", "fallback" },
			["<Esc>"] = { "hide", "fallback" },
			["<PageUp>"] = { "scroll_documentation_up", "fallback" },
			["<PageDown>"] = { "scroll_documentation_down", "fallback" },
		},

		appearance = {
			nerd_font_variant = 'mono'
		},

		completion = { documentation = { auto_show = false } },

		sources = {
			default = { 'lsp', 'path', 'snippets', 'buffer' },
		},

		fuzzy = { implementation = "prefer_rust_with_warning" }
	},
	opts_extend = { "sources.default" }
}
