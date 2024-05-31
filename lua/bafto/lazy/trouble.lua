return {
	'folke/trouble.nvim',

	dependencies = {
		'nvim-tree/nvim-web-devicons',
	},

	opts = {
		focus = true,
	},

	cmd = 'Trouble',

	keys = {
		{ '<leader>t',  '<cmd>Trouble diagnostics toggle<CR>',              { desc = 'Toggle Trouble all diagnostics' } },
		{ '<leader>bt', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', { desc = 'Toggle Trouble buffer diagnostics' } },
	},
}
