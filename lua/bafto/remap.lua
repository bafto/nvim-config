vim.keymap.set({ "n", "i", "v" }, "ö", "<Esc>", { desc = "Easy Escape" })
vim.keymap.set("i", "<C-o>", "ö", { desc = "ö" })

vim.keymap.set("n", "<leader>pv", ":NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })

-- enables moving of highlighted sections with J and K (awesome)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

-- cursor stays in place when appending next line to current line
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines" })
-- cursor stays in the middle when jumping half-page wise
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })
-- search terms stay in the middle
vim.keymap.set("n", "n", "nzzzv", { desc = "Find next" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Find previous" })

-- <leader>p is now like p but the previous register is saved
vim.keymap.set("x", "<leader>p", "\"_dP", { desc = "Paste without replace" })
-- <leader>ps now pastes from system clipboard
-- vim.keymap.set("n", "<leader>ps", "\"+p", { desc = "Paste from system clipboard" })
-- vim.keymap.set("v", "<leader>ps", "\"+p", { desc = "Paste from system clipboard" })

-- <leader>y yanks to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y", { desc = "Yank to system clipboard" })
vim.keymap.set("v", "<leader>y", "\"+y", { desc = "Yank to system clipboard" })
vim.keymap.set("v", "<leader>Y", "\"+Y", { desc = "Yank to system clipboard" })

-- <leader>d now deletes to void register (previous register is saved)
vim.keymap.set("n", "<leader>d", "\"_d", { desc = "Delete without replace" })
vim.keymap.set("v", "<leader>d", "\"_d", { desc = "Delete without replace" })

-- better safe than sorry
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Ex mode (Nop)" })

-- control + s saves the current buffer (muscle memory)
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save file" })
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save file" })

-- U for redo because <C-R> is already taken by harpoon
vim.keymap.set("n", "U", "<C-R>", { desc = "Redo" })

-- <leader>ee for if err != nil in Go
vim.keymap.set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>O", { desc = "if err != nil" })
-- <leader>er for if err != nil and return in Go
vim.keymap.set("n", "<leader>er", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>jo<Esc>",
	{ desc = "if err != nil and return" })

-- <ENTER> for newlines
vim.keymap.set("n", "<ENTER>", "o<ESC>", { desc = "Newline" })
-- this might not work in every terminal
-- vim.keymap.set("n", "<S-ENTER>", "O<ESC>")

-- <ENTER> to replace with newline in visual mode
vim.keymap.set("v", "<ENTER>", "c<ENTER><ESC>kA", { desc = "Replace with newline" })

-- move window with <C-HJKL>
vim.keymap.set("n", "<C-H>", "<C-W><C-H>", { desc = "Move window left" })
vim.keymap.set("n", "<C-J>", "<C-W><C-J>", { desc = "Move window down" })
vim.keymap.set("n", "<C-K>", "<C-W><C-K>", { desc = "Move window up" })
vim.keymap.set("n", "<C-L>", "<C-W><C-L>", { desc = "Move window right" })
-- split horizontally with just <C-W>k instead of K
vim.keymap.set("n", "<C-W>k", "<C-W>K", { desc = "Split horizontally" })

-- resize window with <C-A-Up/Down/Left/Right>
vim.keymap.set("n", "<C-A-Up>", "<cmd>horizontal  resize +5<cr>", { desc = "Increase horizontal window size" })
vim.keymap.set("n", "<C-A-Down>", "<cmd>horizontal  resize -5<cr>", { desc = "Decrease horizontal window size" })
vim.keymap.set("n", "<C-A-Right>", "<cmd>vertical  resize +5<cr>", { desc = "Increase vertical window size" })
vim.keymap.set("n", "<C-A-Left>", "<cmd>vertical  resize -5<cr>", { desc = "Decrease vertical window size" })

-- replace the default <C-L> with <C-C> to clear search highlights
vim.keymap.set("n", "<C-C>", function()
	vim.lsp.buf.clear_references()
	return "<Cmd>nohlsearch|diffupdate|normal! <C-L><CR>"
end, { expr = true, desc = "Clear search highlights" })
