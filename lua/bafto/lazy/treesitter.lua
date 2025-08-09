return {
	'nvim-treesitter/nvim-treesitter',

	build = ":TSUpdate",
	branch = "main",
	version = false,
	lazy = false,

	config = function()
		require('nvim-treesitter').setup {
			-- A list of parser names, or "all" (the five listed parsers should always be installed)
			ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "go", "java", "javascript", "jsdoc", "typescript", "bash", "cmake", "cpp", "dockerfile", "gitignore", "gitcommit", "gomod", "gosum", "html", "json", "llvm", "make", "python", "scala", "sql", "yaml", "markdown_inline", "terraform", "vue", "prolog" },
			ignore_install = {},
			modules = {},

			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = true,

			-- Automatically install missing parsers when entering buffer
			-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
			auto_install = true,

			highlight = {
				enable = true,

				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = false,
			},
			playground = {
				enable = true,
				updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
				persist_queries = false, -- Whether the query persists across vim sessions
			},
		}

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(ev)
				pcall(vim.treesitter.start)
			end,
		})
	end
};
