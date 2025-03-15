return {
	'nvim-tree/nvim-tree.lua',

	dependencies = {
		{ 'nvim-tree/nvim-web-devicons' }
	},

	config = function()
		-- vim.g.loaded_netrw = 1
		-- vim.g.loaded_netrwPlugin = 1

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
			disable_netrw = false,
			hijack_netrw = true,
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
				-- sort by is_directory > extension > name
				sorter = function(nodes)
					table.sort(nodes, function(a, b)
						-- sort directories to the top
						if a.type ~= b.type then
							return a.type < b.type
						end

						-- no nils
						a.extension = a.extension or ""
						b.extension = b.extension or ""

						-- get extension
						for str in string.gmatch(a.extension, '[^\\.]+') do
							a.extension = str or a.extension
						end
						for str in string.gmatch(b.extension, '[^\\.]+') do
							b.extension = str or b.extension
						end

						-- sort by extension
						if a.extension ~= b.extension then
							return a.extension < b.extension
						end

						-- sort by name
						return a.name < b.name
					end)
				end,
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
				timeout = 100,
			},
		}
	end,
}
