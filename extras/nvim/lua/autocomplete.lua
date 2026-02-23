require("blink.cmp").setup({
	keymap = { preset = "enter" },
	appearance = {
		nerd_font_variant = "mono",
		use_nvim_cmp_as_default = true,
	},
	completion = {
		menu = { auto_show = false },
		documentation = { auto_show = false },
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	fuzzy = { implementation = "prefer_rust_with_warning" },
})
