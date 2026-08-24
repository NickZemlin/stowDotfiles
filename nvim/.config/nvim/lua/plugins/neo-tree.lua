-- plugins/neo-tree.lua
-- File explorer configuration (left side)

local nt_commands = require("neo-tree.sources.common.commands")
local nt_renderer = require("neo-tree.ui.renderer")

-- Mark the node under the cursor and step down a line, like yazi's <Space>.
-- Deliberately a function rather than the "select" command name: function
-- mappings get no _visual variant, so the dispatcher never consumes (clears)
-- the mark set when this key is pressed.
local function toggle_mark_and_advance(state)
    nt_commands.select(state)
    vim.cmd("normal! j")
end

-- Shared body for yazi's <C-a> (mark all) and <C-r> (invert marks).
local function mark_visible(state, invert)
    for _, node in ipairs(nt_renderer.get_all_visible_nodes(state.tree)) do
        if node:get_depth() > 1 then
            local id = node:get_id()
            -- store nil, not false, to match how commands.select writes here
            if invert then
                state.selected[id] = not state.selected[id] or nil
            else
                state.selected[id] = true
            end
        end
    end
    nt_renderer.redraw(state)
end

-- The nodes an operation applies to. Yazi's rule: if anything is marked, act on
-- the marks and ignore the hovered node; otherwise act on the hovered node.
-- Neo-tree's own dispatcher instead appends the hovered node to the mark set
-- (ui/renderer.lua:1027), so `d` with two marks would hit three files.
local function target_nodes(state)
    local nodes = {}
    for id in pairs(state.selected) do
        nodes[#nodes + 1] = state.tree:get_node(id)
    end
    if #nodes == 0 then
        nodes[1] = state.tree:get_node()
    end
    state.selected = {}
    return nodes
end

-- yazi's `yank` / `yank --cut`: snapshot the marks into the register, replacing
-- whatever was there. Neo-tree's copy_to_clipboard instead *toggles* each node,
-- so pressing y twice would silently un-yank.
local function yank(state, action)
    local nodes = target_nodes(state)
    state.clipboard = {}
    for _, node in ipairs(nodes) do
        if node.type ~= "message" then
            state.clipboard[node.id] = { action = action, node = node }
        end
    end
    require("neo-tree.events").fire_event("neo_tree_clipboard_changed", { state = state })
    nt_renderer.redraw(state)
end

-- Route through state.commands so the filesystem source's refresh callbacks run.
local function on_targets(command)
    return function(state)
        state.commands[command](state, target_nodes(state))
    end
end

-- Because y/x/d/D are function mappings, neo-tree does not auto-register their
-- visual-mode counterparts (it only does that for string command names, see
-- ui/renderer.lua:1036). Register them by hand so `v` + motion + op still works.
local visual_ops = {
    y = function(state, nodes) state.commands.copy_to_clipboard_visual(state, nodes) end,
    x = function(state, nodes) state.commands.cut_to_clipboard_visual(state, nodes) end,
    d = function(state, nodes) state.commands.trash_visual(state, nodes) end,
    D = function(state, nodes) state.commands.delete_visual(state, nodes) end,
}

local function map_visual_ops(bufnr)
    for key, run in pairs(visual_ops) do
        vim.keymap.set("v", key, function()
            local first, last = vim.fn.line("v"), vim.fn.line(".")
            if first > last then first, last = last, first end
            vim.api.nvim_feedkeys(
                vim.api.nvim_replace_termcodes("<esc>", true, false, true), "i", true)
            vim.schedule(function()
                local state = require("neo-tree.sources.manager").get_state_for_window()
                if not state then return end
                local nodes = {}
                for line = first, last do
                    local node = state.tree:get_node(line)
                    if node then nodes[#nodes + 1] = node end
                end
                if #nodes > 0 then
                    state.selected = {}
                    run(state, require("neo-tree.utils").unique(nodes))
                end
            end)
        end, { buffer = bufnr, noremap = true, nowait = true })
    end
end

require("neo-tree").setup({
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
    sort_case_insensitive = false,
    -- neo-tree's macOS default is `trash --`, but macOS 26's built-in
    -- /usr/bin/trash treats `--` as a filename and warns on every delete.
    -- Paths from neo-tree are absolute, so the separator buys us nothing.
    trash = { command = { "trash" } },
    default_component_configs = {
        container = { enable_character_fade = true },
        indent = {
            indent_size = 2,
            padding = 1,
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "NeoTreeIndent",
            with_expanders = true,
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
        },
        icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "󰜌",
            default = "*",
            highlight = "NeoTreeFileIcon"
        },
        modified = { symbol = "[+]", highlight = "NeoTreeModified" },
        name = {
            trailing_slash = false,
            use_git_status_colors = true,
        },
        git_status = {
            symbols = {
                added     = "✚",
                modified  = "",
                deleted   = "✖",
                renamed   = "󰁕",
                untracked = "★",
                ignored   = "◌",
            }
        }
    },
    window = {
        position = "left",
        width = 40,
        mapping_options = {
            noremap = true,
            nowait = true,
        },
        mappings = {
            -- Selection / marking: mirrors yazi (see keymap.toml).
            ["<space>"] = { toggle_mark_and_advance, desc = "toggle mark" },
            ["<tab>"] = "toggle_node",
            ["v"] = {
                function() vim.cmd("normal! V") end,
                desc = "visual select",
            },
            ["<C-a>"] = {
                function(state) mark_visible(state, false) end,
                desc = "mark all",
            },
            ["<C-r>"] = {
                function(state) mark_visible(state, true) end,
                desc = "invert marks",
            },
            ["<2-LeftMouse>"] = "open",
            ["<cr>"] = "open",
            ["<esc>"] = {
                function(state)
                    -- yazi's layered escape: drop marks first, then the preview
                    if next(state.selected) then
                        nt_commands.clear_selection(state)
                    else
                        nt_commands.revert_preview(state)
                    end
                end,
                desc = "clear marks / revert preview",
            },
            ["P"] = { "toggle_preview", config = { use_float = true } },
            ["l"] = "focus_preview",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            ["t"] = "open_tabnew",
            ["w"] = "open_with_window_picker",
            ["C"] = "close_node",
            ["z"] = "close_all_nodes",
            ["R"] = "refresh",
            ["a"] = { "add", config = { show_path = "relative" }, },
            -- File ops: mirrors yazi. d trashes, D deletes for good.
            ["d"] = { on_targets("trash_visual"), desc = "trash" },
            ["D"] = { on_targets("delete_visual"), desc = "delete permanently" },
            ["T"] = "none",
            ["r"] = "rename",
            ["y"] = { function(state) yank(state, "copy") end, desc = "yank" },
            ["x"] = { function(state) yank(state, "cut") end, desc = "yank (cut)" },
            ["Y"] = "clear_clipboard",
            ["X"] = "clear_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy",
            ["m"] = "move",
            ["q"] = "close_window",
            ["?"] = "show_help",
        }
    },
    nesting_rules = {},
    filesystem = {
        filtered_items = {
            visible = false,
            hide_dotfiles = true,
            hide_gitignored = true,
            hide_hidden = true,
            hide_by_name = {
                ".DS_Store",
                "thumbs.db",
                "node_modules"
            },
        },
        follow_current_file = {
            enabled = true,
            leave_dirs_open = false,
        },
        group_empty_dirs = false,
        scan_mode = "shallow",
        -- Watch the filesystem via libuv so the tree tracks external changes
        -- (yazi, git checkout, shell) instead of only refreshing on :w.
        -- Also drives git status updates; .git internals are skipped upstream
        -- to avoid event storms, and only expanded folders are watched.
        use_libuv_file_watcher = true,
    },
    buffers = {
        show_unloaded = true,
        window = {
            mappings = {
                ["bd"] = "buffer_delete",
            }
        }
    },
    git_status = {
        window = {
            position = "float",
            mappings = {
                ["A"]  = "git_add_all",
                ["gu"] = "git_unstage_file",
                ["ga"] = "git_add_file",
                ["gr"] = "git_revert_file",
                ["gc"] = "git_commit",
                ["gp"] = "git_push",
                ["gg"] = "git_commit_and_push",
            }
        }
    },
    event_handlers = {
        {
            -- Show relative line numbers inside the neo-tree window.
            event = "neo_tree_buffer_enter",
            handler = function()
                vim.opt_local.number = true
                vim.opt_local.relativenumber = true
                map_visual_ops(0)
            end,
        },
    },
})
