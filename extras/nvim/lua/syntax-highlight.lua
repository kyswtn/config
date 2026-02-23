vim.cmd("syntax off")
local t = {
	"lua",
	"nix",
	"kdl",
	"rust",
	"json",
	"html",
	"css",
	"jsonc",
	"javascript",
	"typescript",
	"astro",
	"python",
	"bash",
}
require("nvim-treesitter").install(t)
vim.api.nvim_create_autocmd("FileType", {
	pattern = t,
	callback = function(event)
		local l = vim.treesitter.language.get_lang(event.match) or event.match
		pcall(vim.treesitter.start, event.buf, l)
	end,
})
