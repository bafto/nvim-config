return {
	'mfussenegger/nvim-dap',

	lazy = true,
	keys = {
		-- keymaps
		{ '<leader>dc',  function() require('dap').continue() end,          { desc = 'debug launch/continue' } },
		{ '<leader>dso', function() require('dap').step_over() end,         { desc = 'debug step over' } },
		{ '<leader>dsi', function() require('dap').step_into() end,         { desc = 'debug step into' } },
		{ '<leader>db',  function() require('dap').toggle_breakpoint() end, { desc = 'debug toggle breakpoint' } },
		{ '<leader>dB',  function() require('dap').set_breakpoint() end,    { desc = 'debug set breakpoint' } },
		{ '<leader>dtr', function() require('dap').repl.toggle() end,       { desc = 'debug repl' } },
		{ '<leader>ddc', function() require('dap').disconnect() end,        { desc = 'debug disconnect' } },
		{ '<leader>dr',  function() require('dap').restart() end,           { desc = 'debug restart' } },
	},

	config = function()
		local dap = require('dap')

		-- for additional adapters visit https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation

		dap.adapters.delve = {
			type = 'server',
			port = '${port}',
			executable = {
				command = 'dlv',
				args = { 'dap', '-l', '127.0.0.1:${port}' }
			}
		}
		dap.adapters.go = dap.adapters.delve

		dap.configurations.go = {
			{
				type = 'delve',
				name = 'Debug file',
				request = 'launch',
				mode = 'debug',
				program = '${file}',
			},
			{
				type = 'delve',
				name = 'Debug test',
				request = 'launch',
				mode = 'test',
				program = '${file}'
			},
			{
				type = 'delve',
				name = 'Debug module',
				request = 'launch',
				mode = 'debug',
				program = './${relativeFileDirname}',
			},
			{
				type = 'delve',
				name = 'Debug workspace module',
				request = 'launch',
				mode = 'debug',
				program = './${workspaceFolder}',
			},
			{
				type = 'delve',
				name = 'Debug DDP',
				request = 'launch',
				mode = 'debug',
				program = '${workspaceFolder}/cmd/kddp/',
				args = {
					'kompiliere',
					'${workspaceFolder}/build/test.ddp',
					"-o",
					"${workspaceFolder}/build/test.exe",
					"--wortreich",
					"--nichts_loeschen"
				}
			},
		}
		if vim.fn.isdirectory('.vscode/launch.json') then
			require('dap.ext.vscode').load_launchjs('.vscode/launch.json')
		end

		dap.set_log_level('TRACE')
	end
}
