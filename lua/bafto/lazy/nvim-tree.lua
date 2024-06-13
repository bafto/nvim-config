return {
	'nvim-tree/nvim-tree.lua',

	dependencies = {
		{ 'nvim-tree/nvim-web-devicons' }
	},

	config = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		vim.opt.termguicolors = true

		require('nvim-web-devicons').setup {
			default = true,
			strict = true,
			override_by_extension = {
				["go"] = {
					icon = "󰟓",
					color = "#00ADD8",
					name = "Go"
				},
			},
		}

		require('nvim-tree').setup {
			actions = {
				open_file = {
					quit_on_open = true,
				},
			},
			view = {
				adaptive_size = true,
			},
			update_focused_file = {
				enable = true,
			},
			sort = {
				sorter = "extension",
			},
			diagnostics = {
				enable = true,
				show_on_dirs = true,
			},
			filters = {
				git_ignored = false,
			},
			renderer = {
				icons = {
					glyphs = {
						git = {
							ignored = "",
						}
					}
				}
			},
			git = {
				enable = true,
				timeout = 250,
			},
		}
	end,
}
