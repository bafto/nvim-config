local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim';
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
	spec = "bafto.lazy",
};
--[[
return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	use {

		'nvim-telescope/telescope.nvim', tag = '0.1.5',
		-- or                            , branch = '0.1.x',
		requires = { { 'nvim-lua/plenary.nvim' }, },
	}

	use {
		'Mofiqul/vscode.nvim',
		as = 'vscode',
		config = function()
			vim.cmd('colorscheme vscode')
		end,
	}

	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
	}
	use {
		'nvim-treesitter/playground',
		requires = {
			'nvim-treesitter/nvim-treesitter',
		},
	}

	use {
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		requires = { { "nvim-lua/plenary.nvim" } }
	}

	use 'mbbill/undotree'

	use 'tpope/vim-fugitive'

	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		requires = {
			--- Uncomment these if you want to manage the language servers from neovim
			{ 'williamboman/mason.nvim' },
			{ 'williamboman/mason-lspconfig.nvim' },

			-- LSP Support
			{ 'neovim/nvim-lspconfig' },
			-- Autocompletion
			{ 'hrsh7th/nvim-cmp' },
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'hrsh7th/cmp-buffer' },
			{ 'hrsh7th/cmp-path' },
			{ 'hrsh7th/cmp-nvim-lua' },
			{ 'rafamadriz/friendly-snippets' },
			{ 'saadparwaiz1/cmp_luasnip' },
			{ 'L3MON4D3/LuaSnip' },
		}
	}

	use 'ThePrimeagen/vim-be-good'

	use 'github/copilot.vim'

	use 'jiangmiao/auto-pairs'

	use {
		'scalameta/nvim-metals',
		requires = { 'nvim-lua/plenary.nvim' }
	}

	use 'lukas-reineke/lsp-format.nvim'

	use {
		'nvim-tree/nvim-tree.lua',
		requires = {
			{ 'nvim-tree/nvim-web-devicons' }
		}
	}

	use {
		"kylechui/nvim-surround",
		tag = "v2.1.4",
	}

	use {
		'folke/trouble.nvim',
		requires = {
			{ 'kyazdani42/nvim-web-devicons' },
		},
	}

	use {
		'windwp/nvim-ts-autotag',
		requires = {
			{ 'nvim-treesitter/nvim-treesitter' }
		},
	}

	use {
		'folke/twilight.nvim',
		requires = {
			{ 'nvim-treesitter/nvim-treesitter' }
		}
	}

	use {
		'folke/zen-mode.nvim',
		requires = {
			{ 'folke/twilight.nvim' }
		}
	}

	use {
		'folke/todo-comments.nvim',
		requires = {
			{ 'nvim-lua/plenary.nvim' }
		}
	}
end)
]]
