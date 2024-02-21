local function toggle_telescope(harpoon_files)
	local harpoon = require("harpoon")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local file_paths = {}
	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end

	require("telescope.pickers").new({}, {
		prompt_title = "Harpoon",
		finder = require("telescope.finders").new_table({
			results = file_paths,
		}),
		previewer = conf.file_previewer({}),
		sorter = conf.generic_sorter({}),
		attach_mappings = function(_, map)
			local function list_find(list, func)
				for i, v in ipairs(list) do
					if func(v, i, list) then
						return i, v
					end
				end
			end

			actions.select_default:replace(function(prompt_bufnr)
				local curr_picker = action_state.get_current_picker(prompt_bufnr)
				local curr_entry = action_state.get_selected_entry()
				if not curr_entry then
					return
				end
				actions.close(prompt_bufnr)

				local idx, _ = list_find(curr_picker.finder.results, function(v)
					if curr_entry.value == v.value then
						return true
					end
					return false
				end)
				harpoon:list():select(idx)
			end)
			-- Delete entries from harpoon list with <C-d>
			map({ 'n', 'i' }, '<C-d>', function(prompt_bufnr)
				local current_picker = action_state.get_current_picker(prompt_bufnr)

				current_picker:delete_selection(function(selection)
					harpoon:list():removeAt(selection.index)
				end)
			end
			)
			return true
		end
	}):find()
end

return {
	'ThePrimeagen/harpoon',

	branch = 'harpoon2',

	dependencies = {
		'nvim-lua/plenary.nvim',
	},

	keys = {
		{ '<C-A>', function() require('harpoon'):list():append() end },
		{ '<C-E>', function() require('harpoon'):list():select(1) end },
		{ '<C-R>', function() require('harpoon'):list():select(2) end },
		{ '<C-T>', function() require('harpoon'):list():select(3) end },
		{ '<C-Z>', function() require('harpoon'):list():select(4) end },
		{ '<C-J>', function() require('harpoon'):list():prev() end },
		{ '<C-K>', function() require('harpoon'):list():next() end },
		-- use telescope as UI
		{ "<C-Q>", function() toggle_telescope(require('harpoon'):list()) end, { desc = "Open harpoon window" } },
		-- use harpoon as UI
		--{ "<C-Q>", function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end },
	},
}
