return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
			{
				"s1n7ax/nvim-window-picker", -- for open_with_window_picker keymaps
				version = "2.*",
				config = function()
					require("window-picker").setup({
						filter_rules = {
							include_current_win = false,
							autoselect_one = true,
							-- filter using buffer options
							bo = {
								-- if the file type is one of following, the window will be ignored
								filetype = { "neo-tree", "neo-tree-popup", "notify" },
								-- if the buffer type is one of following, the window will be ignored
								buftype = { "terminal", "quickfix" },
							},
						},
					})
				end,
			},
		},
		lazy = false,
		config = function()
			-- If you want icons for diagnostic errors, you'll need to define them somewhere.
			-- In Neovim v0.10+, you can configure them in vim.diagnostic.config(), like:
			vim.diagnostic.config({
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = '',
						[vim.diagnostic.severity.WARN] = '',
						[vim.diagnostic.severity.INFO] = '',
						[vim.diagnostic.severity.HINT] = '󰌵',
					},
				}
			})

			vim.keymap.set("n", "<leader>pv", "<Cmd>Neotree toggle<CR>")

			require("neo-tree").setup({
				event_handlers = {
					{
						event = "file_opened",
						handler = function(file_path)
							--auto close
							require("neo-tree").close_all()
						end
					},
				},
				close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
				popup_border_style = "NC", -- or "" to use 'winborder' on Neovim v0.11+
				enable_git_status = true,
				enable_diagnostics = true,
				open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
				open_files_using_relative_paths = false,
				sort_case_insensitive = false,                         -- used when sorting files and directories in the tree
				sort_function = function(a, b)
					-- sort directories to the top
					if a.type ~= b.type then
						return a.type < b.type
					end

					-- no nils
					a.extension = a.extension or ""
					b.extension = b.extension or ""

					-- get extension
					for str in string.gmatch(a.extension, '[^\\.]+') do
						a.extension = str or a.extension
					end
					for str in string.gmatch(b.extension, '[^\\.]+') do
						b.extension = str or b.extension
					end

					-- sort by extension
					if a.extension ~= b.extension then
						return a.extension < b.extension
					end

					if a.name == nil and b.name == nil then
						return true
					end

					-- sort by name
					return a.name < b.name
				end,
				default_component_configs = {
					container = {
						enable_character_fade = true,
					},
					indent = {
						indent_size = 2,
						padding = 1, -- extra padding on left hand side
						-- indent guides
						with_markers = true,
						indent_marker = "│",
						last_indent_marker = "└",
						highlight = "NeoTreeIndentMarker",
						-- expander config, needed for nesting files
						with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
						expander_collapsed = "",
						expander_expanded = "",
						expander_highlight = "NeoTreeExpander",
					},
					icon = {
						folder_closed = "",
						folder_open = "",
						folder_empty = "󰜌",
						provider = function(icon, node, state) -- default icon provider utilizes nvim-web-devicons if available
							if node.type == "file" or node.type == "terminal" then
								local success, web_devicons = pcall(require, "nvim-web-devicons")
								local name = node.type == "terminal" and "terminal" or node.name
								if success then
									local devicon, hl = web_devicons.get_icon(name)
									icon.text = devicon or icon.text
									icon.highlight = hl or icon.highlight
								end
							end
						end,
						-- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
						-- then these will never be used.
						default = "*",
						highlight = "NeoTreeFileIcon",
					},
					modified = {
						symbol = "[+]",
						highlight = "NeoTreeModified",
					},
					name = {
						trailing_slash = false,
						use_git_status_colors = true,
						highlight = "NeoTreeFileName",
					},
					git_status = {
						symbols = {
							-- Change type
							added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
							modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
							deleted = "✖", -- this can only be used in the git_status source
							renamed = "󰁕", -- this can only be used in the git_status source
							-- Status type
							untracked = "",
							ignored = "",
							unstaged = "󰄱",
							staged = "",
							conflict = "",
						},
					},
					-- If you don't want to use these columns, you can set `enabled = false` for each of them individually
					file_size = {
						enabled = true,
						width = 12, -- width of the column
						required_width = 64, -- min width of window required to show this column
					},
					type = {
						enabled = true,
						width = 10, -- width of the column
						required_width = 122, -- min width of window required to show this column
					},
					last_modified = {
						enabled = true,
						width = 20, -- width of the column
						required_width = 88, -- min width of window required to show this column
					},
					created = {
						enabled = true,
						width = 20, -- width of the column
						required_width = 110, -- min width of window required to show this column
					},
					symlink_target = {
						enabled = false,
					},
				},
				-- A list of functions, each representing a global custom command
				-- that will be available in all sources (if not overridden in `opts[source_name].commands`)
				-- see `:h neo-tree-custom-commands-global`
				commands = {},
				window = {
					position = "left",
					width = 40,
					mapping_options = {
						noremap = true,
						nowait = true,
					},
					mappings = {
						["<space>"] = {
							"toggle_node",
							nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
						},
						["<cr>"] = "open",
						["<esc>"] = "cancel", -- close preview or floating neo-tree window
						["w"] = "open_with_window_picker",
						["C"] = "close_node",
						["z"] = "close_all_nodes",
						["a"] = {
							"add",
							-- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
							-- some commands may take optional config options, see `:h neo-tree-mappings` for details
							config = {
								show_path = "none", -- "none", "relative", "absolute"
							},
						},
						["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
						["d"] = "delete",
						["u"] = "rename",
						["b"] = "rename_basename",
						["y"] = "copy_to_clipboard",
						["x"] = "cut_to_clipboard",
						["p"] = "paste_from_clipboard",
						["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
						["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
						["q"] = "close_window",
						["R"] = "refresh",
						["?"] = "show_help",
						["<"] = "prev_source",
						[">"] = "next_source",
						["i"] = "show_file_details",
					},
				},
				nesting_rules = {},
				filesystem = {
					filtered_items = {
						visible = false, -- when true, they will just be displayed differently than normal items
						hide_dotfiles = false,
						hide_gitignored = false,
						hide_hidden = false, -- only works on Windows for hidden files/directories
					},
					follow_current_file = {
						enabled = true,      -- This will find and focus the file in the active buffer every time
						leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
					},
					hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
					use_libuv_file_watcher = true,
					-- instead of relying on nvim autocmd events.
					window = {
						mappings = {
							["<bs>"] = "navigate_up",
							["."] = "set_root",
							["H"] = "toggle_hidden",
							["/"] = "fuzzy_finder",
							["D"] = "fuzzy_finder_directory",
							["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
							-- ["D"] = "fuzzy_sorter_directory",
							["f"] = "filter_on_submit",
							["<c-x>"] = "clear_filter",
							["[g"] = "prev_git_modified",
							["]g"] = "next_git_modified",
							["o"] = {
								"show_help",
								nowait = false,
								config = { title = "Order by", prefix_key = "o" },
							},
							["oc"] = { "order_by_created", nowait = false },
							["od"] = { "order_by_diagnostics", nowait = false },
							["og"] = { "order_by_git_status", nowait = false },
							["om"] = { "order_by_modified", nowait = false },
							["on"] = { "order_by_name", nowait = false },
							["os"] = { "order_by_size", nowait = false },
							["ot"] = { "order_by_type", nowait = false },
							-- ['<key>'] = function(state) ... end,
						},
						fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
							["<down>"] = "move_cursor_down",
							["<C-n>"] = "move_cursor_down",
							["<up>"] = "move_cursor_up",
							["<C-p>"] = "move_cursor_up",
							["<esc>"] = "close",
							["<S-CR>"] = "close_keep_filter",
							["<C-CR>"] = "close_clear_filter",
							["<C-w>"] = { "<C-S-w>", raw = true },
							{
								-- normal mode mappings
								n = {
									["j"] = "move_cursor_down",
									["k"] = "move_cursor_up",
									["<S-CR>"] = "close_keep_filter",
									["<C-CR>"] = "close_clear_filter",
									["<esc>"] = "close",
								}
							}
							-- ["<esc>"] = "noop", -- if you want to use normal mode
							-- ["key"] = function(state, scroll_padding) ... end,
						},
					},

					commands = {}, -- Add a custom command or override a global one using the same function name
				},
				buffers = {
					follow_current_file = {
						enabled = true, -- This will find and focus the file in the active buffer every time
						--              -- the current file is changed while the tree is open.
						leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
					},
					group_empty_dirs = false, -- when true, empty folders will be grouped together
					show_unloaded = true,
					window = {
						mappings = {
							["d"] = "buffer_delete",
							["bd"] = "buffer_delete",
							["<bs>"] = "navigate_up",
							["."] = "set_root",
							["o"] = {
								"show_help",
								nowait = false,
								config = { title = "Order by", prefix_key = "o" },
							},
							["oc"] = { "order_by_created", nowait = false },
							["od"] = { "order_by_diagnostics", nowait = false },
							["om"] = { "order_by_modified", nowait = false },
							["on"] = { "order_by_name", nowait = false },
							["os"] = { "order_by_size", nowait = false },
							["ot"] = { "order_by_type", nowait = false },
						},
					},
				},
				git_status = {
					window = {
						position = "float",
						mappings = {
							["A"] = "git_add_all",
							["gu"] = "git_unstage_file",
							["gU"] = "git_undo_last_commit",
							["ga"] = "git_add_file",
							["gr"] = "git_revert_file",
							["gc"] = "git_commit",
							["gp"] = "git_push",
							["gg"] = "git_commit_and_push",
							["o"] = {
								"show_help",
								nowait = false,
								config = { title = "Order by", prefix_key = "o" },
							},
							["oc"] = { "order_by_created", nowait = false },
							["od"] = { "order_by_diagnostics", nowait = false },
							["om"] = { "order_by_modified", nowait = false },
							["on"] = { "order_by_name", nowait = false },
							["os"] = { "order_by_size", nowait = false },
							["ot"] = { "order_by_type", nowait = false },
						},
					},
				},
			})
		end,
	},
}
