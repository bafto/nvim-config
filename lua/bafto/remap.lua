vim.keymap.set({ "n", "i", "v", "t" }, "ö", "<Esc>", { desc = "Easy Escape" })
vim.keymap.set({ "i", "t" }, "<C-o>", "ö", { desc = "ö" })

vim.keymap.set("n", "<leader>pv", ":NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })

-- enables moving of highlighted sections with J and K (awesome)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })
vim.keymap.set("v", "L", "dp`[1v", { desc = "Move selection to the right" })
vim.keymap.set("v", "H", "dhhp`[1v", { desc = "Move selection to the left" })


-- cursor stays in place when appending next line to current line
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines" })
-- cursor stays in the middle when jumping half-page wise
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })
-- search terms stay in the middle
vim.keymap.set("n", "n", "nzzzv", { desc = "Find next" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Find previous" })

-- p now keeps the register unchanged
vim.keymap.set("x", "p", "\"_dP", { desc = "Paste without replace" })
-- <leader>ps now pastes from system clipboard
vim.keymap.set("n", "<leader>ps", "\"+p", { desc = "Paste from system clipboard" })
vim.keymap.set("v", "<leader>ps", "\"+p", { desc = "Paste from system clipboard" })

-- <leader>y yanks to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y", { desc = "Yank to system clipboard" })
vim.keymap.set("v", "<leader>y", "\"+y", { desc = "Yank to system clipboard" })
vim.keymap.set("v", "<leader>Y", "\"+Y", { desc = "Yank to system clipboard" })

-- <leader>d now deletes to system clipboard (previous register is saved)
vim.keymap.set("n", "<leader>d", "\"+d", { desc = "Delete without replace" })
vim.keymap.set("v", "<leader>d", "\"+d", { desc = "Delete without replace" })

-- better safe than sorry
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Ex mode (Nop)" })

-- control + s saves the current buffer (muscle memory)
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save file" })
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save file" })

-- U for redo
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

-- resizes the window as expected depending on the side it is on
local function resize_window(opts)
	opts = opts or { amount = '5', vertical = true, increase = true }
	return function()
		local window_pos = vim.api.nvim_win_get_position(0);
		local prefix = '+';

		if opts.vertical then
			local is_left = window_pos[2] <= 0
			if is_left and not opts.increase or not is_left and opts.increase then
				prefix = '-'
			end
			vim.cmd(string.format('vertical resize %s%s', prefix, opts.amount))
		else
			local is_top = window_pos[1] <= 0
			if is_top and opts.increase or not is_top and not opts.increase then
				prefix = '-'
			end
			vim.cmd(string.format('horizontal resize %s%s', prefix, opts.amount))
		end
	end
end

vim.keymap.set({ "n", "t" }, "<C-A-Up>", resize_window({ amount = '5', vertical = false, increase = true }),
	{ desc = "Increase horizontal window size" })
vim.keymap.set({ "n", "t" }, "<C-A-Down>", resize_window({ amount = '5', vertical = false, increase = false }),
	{ desc = "Decrease horizontal window size" })
vim.keymap.set({ "n", "t" }, "<C-A-Right>", resize_window({ amount = '5', vertical = true, increase = true }),
	{ desc = "Increase vertical window size" })
vim.keymap.set({ "n", "t" }, "<C-A-Left>", resize_window({ amount = '5', vertical = true, increase = false }),
	{ desc = "Decrease vertical window size" })

-- replace the default <C-L> with <C-C> to clear search highlights
vim.keymap.set("n", "<C-C>", function()
	vim.lsp.buf.clear_references()
	return "<Cmd>nohlsearch|diffupdate|normal! <C-L><CR>"
end, { expr = true, desc = "Clear search highlights" })
