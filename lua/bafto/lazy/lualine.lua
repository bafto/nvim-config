return {
	'nvim-lualine/lualine.nvim',

	dependencies = {
		'nvim-tree/nvim-web-devicons',
		{
			'letieu/harpoon-lualine',
			dependencies = {
				'ThePrimeagen/harpoon',
				branch = "harpoon2",
			}
		}
	},

	config = function()
		require('lualine').setup {
			options = {
				component_separators = '',
			},
			sections = {
				lualine_c = {
					'%=',
					'filename',
					'harpoon2',
				}
			}
		}
	end
}
