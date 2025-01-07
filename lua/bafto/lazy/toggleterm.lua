return {
	'akinsho/toggleterm.nvim',
	version = '*',

	config = function()
		local util = require('bafto.util')

		local bash_executable = "/usr/bin/bash"
		if util.is_windows() then
			bash_executable = "bash.exe"
		end

		local toggleterm = require('toggleterm')

		toggleterm.setup {
			shell = bash_executable,
			size = 20,
		}

		local num_terminals = 0
		local function toggleTerm(term)
			vim.cmd(term .. 'ToggleTerm')
		end
		local function createTerminal()
			num_terminals = num_terminals + 1
			toggleTerm(tostring(num_terminals))
		end
		local function toggleAllTerminals()
			if num_terminals == 0 then
				createTerminal()
			else
				toggleTerm('')
			end
		end

		vim.keymap.set({ 'n', 'i', 't' }, '<C-q>', function()
			toggleAllTerminals()
		end, { desc = 'toggle terminal' })
		vim.keymap.set({ 'n', 't' }, '<leader>aq', function()
			createTerminal()
		end, { desc = 'toggle terminal' })


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


		vim.api.nvim_create_user_command('GoTest', function()
			local test_name = vim.fn.expand('<cword>')
			toggleterm.exec('go test -run="' .. test_name .. '" -v "./' .. vim.fn.expand('%:.:h') .. '"')
		end, { desc = 'Runs the go command under the cursor' })
	end,
}
