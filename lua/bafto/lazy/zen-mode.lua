return {
	'folke/zen-mode.nvim',

	depedencies = {
		'folke/twilight.nvim',
	},

	keys = {
		{ '<leader>zen', ':ZenMode<CR>', { desc = 'toggle zen mode' } },

		cmd = {
			'ZenMode',
		},
	}
}
