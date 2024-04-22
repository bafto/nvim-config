return {
	'jiangmiao/auto-pairs',
	{
		'scalameta/nvim-metals',

		dependencies = {
			'nvim-lua/plenary.nvim',
		},

		ft = 'scala',
	},
	{

		'windwp/nvim-ts-autotag',

		dependencies = {
			'nvim-treesitter/nvim-treesitter'
		},
	},
	'ThePrimeagen/vim-be-good',
	'tpope/vim-commentary',
}
