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
		local ignore_patterns = '{**/.git/*,**/node_modules/*,**/llvm-project/*,**/llvm_build/*,**/pcre2/*}'
		require('todo-comments').setup {
			search = {
				command = "rg",
				args = {
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"-g",
					"!" .. ignore_patterns,
				},
				-- regex that will be used to match keywords.
				-- don't replace the (KEYWORDS) placeholder
				pattern = [[\b(KEYWORDS):]], -- ripgrep regex
				-- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
			},
		}

		vim.api.nvim_create_user_command('Todo', function()
			vim.cmd('TodoTelescope')
		end, { desc = 'Open todo' })
	end,
}
