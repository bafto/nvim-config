local util = require('bafto.util')

-- relative line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- indent using tabs which appear as 4 spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 0
vim.opt.expandtab = false
vim.opt.shiftwidth = 4

-- replace tabs with 2 spaces for java
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "java" },
	callback = function()
		vim.opt.tabstop = 2
		vim.opt.expandtab = true
		vim.opt.shiftwidth = 2
	end
})

-- use 4 spaces for xml
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "xml" },
	callback = function()
		vim.opt.tabstop = 4
		vim.opt.expandtab = true
		vim.opt.shiftwidth = 4
	end
})

vim.opt.smartindent = true

vim.opt.wrap = false

-- highlight current line
vim.opt.cursorline = true

-- incremental search
-- vim.opt.hlsearch = false -- if set to true, it highlights all matches, not just the current one
vim.opt.incsearch = true

vim.opt.termguicolors = true

-- scroll offset
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 250
vim.opt.timeoutlen = 500

-- if you want to enforce the max 80 characters rule
-- vim.opt.colorcolumn = "80"

-- " " = "<leader>"
vim.g.mapleader = " "

-- persistent undo

-- Function to create the undo directory if it doesn't exist
local function setup_undo_directory()
	local home_directory

	-- Check the operating system
	if util.is_windows() then
		-- Windows
		home_directory = vim.fn.substitute(vim.fn.expand("$USERPROFILE"), "\\", "/", "g")
	else
		-- Unix-like systems
		home_directory = vim.fn.expand("~")
	end

	local undo_directory = home_directory .. '/.vimundo'

	-- Check if the directory exists
	if vim.fn.isdirectory(undo_directory) == 0 then
		-- If not, create it
		vim.fn.mkdir(undo_directory, 'p')
	end
end
-- Call the setup function to create the undo directory
setup_undo_directory()

-- Set undo history to the specified directory
vim.o.undodir = vim.fn.expand('~/.nvimundo')
vim.o.undofile = true

-- update diagnostics in insert mode
vim.diagnostic.update_in_insert = true

-- no invisible end of line
vim.cmd("set nofixendofline")

-- git bash fix
if (util.is_windows()) and vim.fn.executable("bash.exe") then
	vim.o.shell = vim.fn.exepath("bash.exe")
end

-- git bash fix 2
if string.gmatch(vim.o.shell, "bash.exe") then
	vim.o.shellcmdflag = "-c"
	vim.o.shellxquote = ""
end

-- no more swapfiles
vim.opt.swapfile = false
-- no shada files
vim.opt.shadafile = "NONE"

-- highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
	pattern = '*',
	callback = function()
		vim.highlight.on_yank({
			higroup = 'IncSearch',
			timeout = 80,
		})
	end,
})

vim.opt.diffopt = "internal,filler,closeoff,vertical"
