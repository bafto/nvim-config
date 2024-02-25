vim.keymap.set("n", "<leader>pv", ":NvimTreeToggle<CR>")

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
-- <leader>ps now pastes from system clipboard
vim.keymap.set("n", "<leader>ps", "\"+p")
vim.keymap.set("v", "<leader>ps", "\"+p")

-- <leader>y yanks to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>Y", "\"+Y")

-- <leader>d now deletes to void register (previous register is saved)
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- better safe than sorry
vim.keymap.set("n", "Q", "<nop>")

-- control + s saves the current buffer (muscle memory)
vim.keymap.set("n", "<C-s>", ":w<CR>")
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a")

-- U for redo because <C-R> is already taken by harpoon
vim.keymap.set("n", "U", "<C-R>")

-- <leader>ee for if err != nil in Go
vim.keymap.set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>jo<Esc>")

-- <ENTER> for newlines
vim.keymap.set("n", "<ENTER>", "o<ESC>")
-- this might not work in every terminal
-- vim.keymap.set("n", "<S-ENTER>", "O<ESC>")

-- <ENTER> to replace with newline in visual mode
vim.keymap.set("v", "<ENTER>", "c<ENTER><ESC>kA")

-- open lazy
vim.keymap.set("n", "<leader>lazy", ":Lazy<CR>")

-- move window with <C-HJKL>
vim.keymap.set("n", "<C-H>", "<C-W><C-H>")
vim.keymap.set("n", "<C-J>", "<C-W><C-J>")
vim.keymap.set("n", "<C-K>", "<C-W><C-K>")
vim.keymap.set("n", "<C-L>", "<C-W><C-L>")
-- split horizontally with just <C-W>k instead of K
vim.keymap.set("n", "<C-W>k", "<C-W>K")

-- replace the default <C-L> with <C-C> to clear search highlights
vim.keymap.set("n", "<C-C>", function()
	vim.lsp.buf.clear_references()
	return "<Cmd>nohlsearch|diffupdate|normal! <C-L><CR>"
end, { expr = true })
