-- plugins/git-dev.lua
-- Open remote git repositories in ephemeral shallow clones.

require("git-dev").setup({
	ephemeral = true, -- Delete the clone when Neovim exits
	read_only = true, -- Remote buffers are unmodifiable
	cd_type = "tab", -- Scope the cwd change to the new tab only

	-- Open each repo in its own tab, browsed via neo-tree.
	opener = function(dir, _, selected_path)
		vim.cmd("tabnew")
		vim.cmd("Neotree " .. dir)
		if selected_path then
			vim.cmd("edit " .. selected_path)
		end
	end,
})

-- Commands only (:GitDevOpen, :GitDevHistory, ...); no keymaps by design.
-- If keymaps are added later they belong in lua/init-keymap.lua.
