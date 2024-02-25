return {
	'folke/todo-comments.nvim',

	depedencies = {
		'nvim-lua/plenary.nvim',
	},

	config = function()
		require('todo-comments').setup {}

		vim.keymap.set('n', '<leader>todo', ':TodoTelescope<CR>', { desc = 'Open todo' });
	end,
}
