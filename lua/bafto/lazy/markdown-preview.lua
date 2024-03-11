return {
	'iamcco/markdown-preview.nvim',

	build = "cd app && npm install",

	ft = { "markdown" },

	cmd = { "MarkdownPreviewToggle",
		"MarkdownPreview",
		"MarkdownPreviewStop",
	},

	keys = {
		{ '<leader>preview', ':MarkdownPreviewToggle<CR>', { desc = 'Toggle Markdown Preview' } }
	}
}
