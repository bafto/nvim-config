return {
	'nvim-telescope/telescope.nvim',

	tag = '0.1.5',

	dependencies = {
		'nvim-lua/plenary.nvim'
	},

	config = function()
		require('telescope').setup {
			defaults = {
				file_ignore_patterns = {
					'node_modules/*',
					-- DDP-Projekt specific
					'llvm%-project/*'
				}
			},
		};

		local builtin = require('telescope.builtin')

		vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
		vim.keymap.set('n', '<C-p>', builtin.git_files, {})
		vim.keymap.set('n', '<leader>grep', function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end)
	end
}
