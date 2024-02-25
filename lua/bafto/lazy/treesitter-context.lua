return {
	'nvim-treesitter/nvim-treesitter-context',
	dependencies = {
		'nvim-treesitter/nvim-treesitter',
	},
	config = function()
		require('treesitter-context').setup {}

		vim.keymap.set('n', 'gc', function()
			require('treesitter-context').go_to_context(vim.v.count1)
		end, { silent = true, desc = 'Go to context' })
		vim.keymap.set('n', '<leader>context', ':TSContextToggle<CR>', { silent = true, desc = 'Toggle context' })
	end,
}
