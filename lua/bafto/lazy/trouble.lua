return {
	'folke/trouble.nvim',

	depedencies = {
		'kyazdani42/nvim-web-devicons',
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
