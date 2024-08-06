return {
	'jinh0/eyeliner.nvim',

	dependencies = {
		-- needs to be loaded first for the custom colors to take effect
		'Mofiqul/vscode.nvim',
	},

	config = function()
		require('eyeliner').setup {
			highlight_on_key = true,
			dim = true,
			disable_buftypes = { 'nofile' },
			disable_filetypes = { 'NvimTree' },
		}

		local colors = require('vscode.colors').get_colors()

		local custom_color = function()
			vim.api.nvim_set_hl(0, 'EyelinerPrimary', { fg = colors.vscPink })
			vim.api.nvim_set_hl(0, 'EyelinerSecondary', { fg = colors.vscBlue })
			vim.api.nvim_set_hl(0, 'EyelinerDimmed', { fg = colors.vscGray })
		end

		vim.api.nvim_create_autocmd('ColorScheme', {
			pattern = '*',
			callback = custom_color,
		})
		custom_color()
	end
}
