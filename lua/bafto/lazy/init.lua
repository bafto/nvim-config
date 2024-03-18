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

		depedencies = {
			'nvim-treesitter/nvim-treesitter'
		},
	},
	'ThePrimeagen/vim-be-good',
	'tpope/vim-commentary',
}
