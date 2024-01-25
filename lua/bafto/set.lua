-- relative line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- indent using tabs which appear as 4 spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 0
vim.opt.expandtab = false
vim.opt.shiftwidth = 4

vim.opt.smartindent = true

vim.opt.wrap = false

-- incremental search
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

-- scroll offset
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- if you want to enforce the max 80 characters rule
-- vim.opt.colorcolumn = "80"

vim.g.mapleader = " "

-- persistent undo

-- Function to create the undo directory if it doesn't exist
local function setup_undo_directory()
	local home_directory

	-- Check the operating system
	if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
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
