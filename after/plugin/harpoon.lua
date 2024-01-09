local harpoon = require("harpoon")

harpoon:setup()

-- Remaps

vim.keymap.set("n", "<C-A>", function() harpoon:list():append() end)

vim.keymap.set("n", "<C-E>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-R>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-T>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-Z>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-J>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-K>", function() harpoon:list():next() end)

-- Telescope as UI

local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function toggle_telescope(harpoon_files)
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

-- use telescope as UI
vim.keymap.set("n", "<C-Q>", function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" })
-- use harpoon as UI
--vim.keymap.set("n", "<C-Q>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

