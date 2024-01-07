vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- enables moving of highlighted sections with J and K (awesome)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- cursor stays in place when appending next line to current line
vim.keymap.set("n", "J", "mzJ`z")
-- cursor stays in the middle when jumping half-page wise
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- search terms stay in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- <leader>p is now like p but the previous register is saved
vim.keymap.set("x", "<leader>p", "\"_dP")

-- <leader>y yanks to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>Y", "\"+Y")

-- <leader>d now deletes to void register (previous register is saved)
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- better safe than sorry
vim.keymap.set("n", "Q", "<nop>")

-- <leader>f formats the current buffer
vim.keymap.set("n", "<C-f>", function()
	vim.lsp.buf.format()
end)

-- control + s saves the current buffer (muscle memory)
vim.keymap.set("n", "<C-s>", ":w<CR>")
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a")
