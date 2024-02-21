require('twilight.config').setup {
	context = 13, -- amount of lines we will try to show around the current line
	expand = {
		"table",
		"function",
		"method",
		"function_definition",
		"table_constructor",
		"method_definition",
		"block",
		"body",
		"if_statement",
		"while_statement",
		"for_statement",
	},
}

vim.keymap.set('n', '<leader>focus', ':Twilight<CR>');
