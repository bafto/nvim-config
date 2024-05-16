return {
	'akinsho/toggleterm.nvim',
	version = '*',

	config = function()
		local bash_executable = "/usr/bin/bash"
		if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
			bash_executable = "bash.exe"
		end

		require('toggleterm').setup {
			shell = bash_executable,
			size = 20,
		}

		vim.keymap.set({ 'n', 'i', 't' }, '<C-q>', '<Cmd>ToggleTerm<CR>', { desc = 'toggle terminal' })
		vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = 'enter normal mode' })
		vim.keymap.set('t', 'ö', [[<C-\><C-n>]], { desc = 'enter normal mode' })
		vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], { desc = 'change window left' })
		vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], { desc = 'change window down' })
		vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], { desc = 'change window up' })
		vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], { desc = 'change window right' })
		vim.keymap.set('t', '<C-w>', [[C-\><C-n><C-w>]], { desc = '<C-W>' })

		vim.keymap.set('v', '<leader>e', '<Cmd>ToggleTermSendVisualSelection<CR><Cmd>TermSelect<CR>1<CR><CR>A',
			{ desc = 'execute selection in terminal and enter insert mode' })
		vim.keymap.set('v', '<leader>E', '<Cmd>ToggleTermSendVisualSelection<CR>',
			{ desc = 'execute selection in terminal without selecting terminal' })
	end,
}
