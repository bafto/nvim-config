return {
	'vim-test/vim-test',

	dependencies = {
		'akinsho/toggleterm.nvim',
	},

	config = function()
		local toggleterm = require("toggleterm")
		local toggleterm_terminal = require("toggleterm.terminal")

		vim.g["test#custom_strategies"] = {
			tterm = function(cmd)
				toggleterm.exec(cmd)
			end,

			tterm_close = function(cmd)
				local term_id = 0
				toggleterm.exec(cmd, term_id)
				toggleterm_terminal.get_or_create_term(term_id):close()
			end,
		}

		vim.g["test#strategy"] = "tterm"
	end
}
