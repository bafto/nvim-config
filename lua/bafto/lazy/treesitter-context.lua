return {
	'nvim-treesitter/nvim-treesitter-context',
	dependencies = {
		'nvim-treesitter/nvim-treesitter',
	},
	config = function()
		require('treesitter-context').setup {}

		vim.keymap.set('n', '<leader>gc', function()
			require('treesitter-context').go_to_context(vim.v.count1)
		end, { silent = true })
		vim.keymap.set('n', '<leader>context', ':TSContextToggle<CR>', { silent = true })
	end,
}
