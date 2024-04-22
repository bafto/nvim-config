return {
	'folke/todo-comments.nvim',

	dependencies = {
		'nvim-lua/plenary.nvim',
	},

	cmd = {
		'TodoTelescope',
		'Todo',
	},

	config = function()
		require('todo-comments').setup {}

		vim.api.nvim_create_user_command('Todo', function()
			vim.cmd('TodoTelescope')
		end, { desc = 'Open todo' })
	end,
}
