return {
	'iamcco/markdown-preview.nvim',

	build = "cd app && npm install && git reset --hard",

	ft = { "markdown" },

	cmd = { "MarkdownPreviewToggle",
		"MarkdownPreview",
		"MarkdownPreviewStop",
	},
}
