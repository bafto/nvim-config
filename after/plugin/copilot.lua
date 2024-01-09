--vim.keymap.set("i", "<Tab>", "copilot#Accept(\"\")", {
--	expr = true,
--	replace_keycodes = false,
--})
vim.g.copilot_no_tab_map = true
-- cylce next and previous
vim.keymap.set("i", "<C-W>", "copilot#Next()", { expr = true })
vim.keymap.set("i", "<C-Q>", "copilot#Previous()", { expr = true })
