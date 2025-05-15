local util = require('bafto.util')

-- respect .editorconfig
vim.g.editorconfig = true

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
	pattern = { "java", "dart" },
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

-- helper to set filetype for file patterns
local function set_filetype(pattern, filetype)
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		pattern = pattern,
		command = "set filetype=" .. filetype,
	})
end

-- set docker-compose filetype for docker-compose ls to work
set_filetype({ "docker-compose.yml" }, "yaml.docker-compose")

-- good when adding a new line for many files
vim.opt.smartindent = true

-- don't wrap lines
vim.opt.wrap = false

-- highlight current line
vim.opt.cursorline = true

-- incremental search
-- vim.opt.hlsearch = false -- if set to true, it highlights all matches, not just the current one
vim.opt.incsearch = true

-- colors!
vim.opt.termguicolors = true

-- scroll offset
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- cursorhold update time
vim.opt.updatetime = 250
-- keybinding timeout
vim.opt.timeoutlen = 500

-- if you want to enforce the max 80 characters rule
-- vim.opt.colorcolumn = "80"

-- " " = "<leader>"
vim.g.mapleader = " "

-- persistent undo
-- Set undo history to the specified directory
vim.o.undodir = vim.fn.expand('~/.nvimundo')
vim.o.undofile = true

-- update diagnostics in insert mode
vim.diagnostic.update_in_insert = true

-- no invisible end of line
vim.o.fixeol = false

-- git bash fix
if (util.is_windows()) and vim.fn.executable("bash.exe") then
	vim.o.shell = vim.fn.exepath("bash.exe")
	vim.o.shellcmdflag = "-c"
	vim.o.shellxquote = ""
end

-- no shada or swap files, they only cause problems for me
vim.opt.swapfile = false
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

-- how diffs are shown
vim.opt.diffopt = "internal,filler,closeoff,vertical"
