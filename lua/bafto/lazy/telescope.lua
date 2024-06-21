return {
	{
		'nvim-telescope/telescope.nvim',

		tag = '0.1.8',

		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope-fzf-native.nvim',
		},

		config = function()
			local tConfig = require('telescope.config')

			local vimgrep_arguments = { unpack(tConfig.values.vimgrep_arguments) }

			-- show hidden files
			table.insert(vimgrep_arguments, '--hidden')
			-- ignore certain directories
			table.insert(vimgrep_arguments, '--glob')
			table.insert(vimgrep_arguments, '!{.git/,node_modules/,llvm-project/,llvm_build/}')

			require('telescope').setup {
				pickers = {
					find_files = {
						hidden = true,
					},
				},
				defaults = {
					layout_strategy = 'vertical',
					path_display = {
						shorten = {
							len = 3,
							exclude = { 1, -1 },
						},
						truncate = true,
					},
					dynamic_preview_title = true,
					vimgrep_arguments = vimgrep_arguments,
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
			vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = 'Find git files' })
		end
	},
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'make -j4',
	},
}
