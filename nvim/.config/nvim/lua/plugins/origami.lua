-- plugins/origami.lua
-- Folding enhancements (LSP/treesitter folds, fold text, pause on search)

require("origami").setup({
	useLspFoldsWithTreesitterFallback = { enabled = true },
	pauseFoldsOnSearch = true,
	foldtext = { enabled = true },
	autoFold = { enabled = true },
	foldKeymaps = { setup = false },
})
