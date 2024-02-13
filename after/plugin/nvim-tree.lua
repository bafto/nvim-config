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
}
