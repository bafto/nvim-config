return {
	'github/copilot.vim',

	config = function()
		--vim.keymap.set("i", "<Tab>", "copilot#Accept(\"\")", {
		--	expr = true,
		--	replace_keycodes = false,
		--})
		vim.g.copilot_no_tab_map = true
		-- cylce next and previous
		vim.keymap.set("i", "<C-R>", "copilot#Next()", { expr = true, desc = "Copilot Next" })
		vim.keymap.set("i", "<C-E>", "copilot#Previous()", { expr = true, desc = "Copilot Previous" })
	end
}
