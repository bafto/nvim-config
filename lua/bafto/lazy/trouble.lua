return {
	'folke/trouble.nvim',

	depedencies = {
		'kyazdani42/nvim-web-devicons',
	},

	keys = {
		{ '<leader>t', ':TroubleToggle<CR>' },
	},

	cmd = {
		'TroubleToggle',
		'Trouble',
		'TroubleClose',
		'TroubleRefresh',
	},
}
