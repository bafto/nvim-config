return {
	'folke/trouble.nvim',

	dependencies = {
		'nvim-tree/nvim-web-devicons',
	},

	keys = {
		{ '<leader>t', ':TroubleToggle<CR>', { desc = 'toggle trouble' } },
	},

	cmd = {
		'TroubleToggle',
		'Trouble',
		'TroubleClose',
		'TroubleRefresh',
	},
}
