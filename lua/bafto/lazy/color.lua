return {
	'Mofiqul/vscode.nvim',

	name = 'vscode',

	config = function()
		function ApplyColor(color)
			color = color or "vscode"
			vim.cmd.colorscheme(color)
		end

		-- for style, but not for practicality
		function SetBackgroundTransparent()
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		end

		ApplyColor()
		-- SetBackgroundTransparent()
	end,
};
