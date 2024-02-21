return {
	'jiangmiao/auto-pairs',
	'lukas-reineke/lsp-format.nvim',
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
}
