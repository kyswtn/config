local d = vim.diagnostic.severity
vim.diagnostic.config({
	signs = {
		text = {
			[d.ERROR] = "●",
			[d.WARN] = "●",
			[d.INFO] = "●",
			[d.HINT] = "󰌵",
		},
	},
})
require("tiny-inline-diagnostic").setup({
	preset = "simple",
	signs = {
		diag = "●",
	},
})
