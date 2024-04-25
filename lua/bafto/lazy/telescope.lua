return {
	{
		'nvim-telescope/telescope.nvim',

		tag = '0.1.5',

		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope-fzf-native.nvim',
		},

		config = function()
			require('telescope').setup {
				defaults = {
					layout_strategy = 'vertical',
					file_ignore_patterns = {
						'target/*',
						'node_modules/*',
						-- DDP-Projekt specific
						'llvm%-project/*'
					},
					path_display = {
						shorten = {
							len = 3,
							exclude = { 1, -1 },
						},
						truncate = true,
					},
					dynamic_preview_title = true,
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			};
			require('telescope').load_extension('fzf');

			local builtin = require('telescope.builtin')

			vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
			vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
			vim.keymap.set('n', '<leader>gr', function()
				vim.ui.input({ prompt = 'Grep > ' }, function(value)
					builtin.grep_string({ search = value })
				end)
			end, { desc = 'Grep from prompt' })
			vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
		end
	},
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'make -j4',
	},
}
