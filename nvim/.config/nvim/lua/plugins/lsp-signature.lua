-- plugins/lsp-signature.lua
-- Automatic signature help while typing (floating window, signature only)

require("lsp_signature").setup({
	bind = true,
	floating_window = true,      -- keep the floating window
	hint_enable = false,         -- no virtual-text parameter hint
	doc_lines = 0,               -- signature only, no documentation
	handler_opts = {
		border = "rounded",
	},
})
