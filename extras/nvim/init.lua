local o = vim.opt
-- No *.{bak,swp}
o.backup = false
o.writebackup = false
o.swapfile = false
o.undofile = false
o.undolevels = 10000
-- UI
o.termguicolors = true
o.number = true
o.relativenumber = true
o.cursorline = true
o.signcolumn = "yes"
o.wrap = false
o.laststatus = 3
o.splitbelow = true
o.splitright = true
-- Editor
o.tabstop = 2
o.expandtab = true
o.shiftwidth = 2

-- Setup clipboard with OSC 52
local is_mac = vim.fn.has("mac") == 1
local is_linux = vim.fn.has("unix") == 1 and not is_mac
if is_mac then
	-- macOS: use system clipboard directly
	vim.opt.clipboard = "unnamedplus"
elseif is_linux then
	-- Linux VPS: use OSC52 provider
	vim.g.clipboard = {
		name = "OSC52",
		copy = {
			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
		},
		paste = {
			["+"] = require("vim.ui.clipboard.osc52").paste("+"),
			["*"] = require("vim.ui.clipboard.osc52").paste("*"),
		},
	}
	vim.opt.clipboard = "unnamedplus"
end

-- Common keybinds
vim.g.mapleader = " "
local m = vim.keymap.set
m("n", "gl", "$", { desc = "Go to end of line" })
m("n", "gh", "^", { desc = "Go to start of line" })
m("v", "<", "<gv")
m("v", ">", ">gv")
m("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
m("n", "<C-j>", "<C-w>j", { desc = "Go to bottom window", remap = true })
m("n", "<C-k>", "<C-w>k", { desc = "Go to top window", remap = true })
m("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })
m("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
m("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
m("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
m("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
m("n", "<A-J>", "<cmd>m .+1<cr>==", { desc = "Move down" })
m("n", "<A-K>", "<cmd>m .-2<cr>==", { desc = "Move up" })
m("i", "<A-J>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
m("i", "<A-K>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
m("v", "<A-J>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
m("v", "<A-K>", ":m '<-2<cr>gv=gv", { desc = "Move up" })
m("n", "<leader>k", "<cmd>norm! K<cr>", { desc = "keywordprg" })
m("t", "<Esc>", "<C-\\><C-n>", { desc = "Escape from terminal to normal mode" })
m("n", "<leader>f", "<cmd>Pick files<cr>", { desc = "Open file picker" })
m("n", "<leader>b", "<cmd>Pick buffers<cr>", { desc = "Open buffer picker" })
m("n", "<leader>h", "<cmd>Pick help<cr>", { desc = "Open help tags" })
m("n", "<leader>/", "<cmd>Pick grep_live<cr>", { desc = "Open live grep" })

-- Command to toggle inline diagnostics
vim.api.nvim_create_user_command("DiagnosticsToggleVirtualText", function()
	local current_value = vim.diagnostic.config().virtual_text
	vim.diagnostic.config({ virtual_text = not current_value })
end, {})

-- Command to toggle diagnostics
vim.api.nvim_create_user_command("DiagnosticsToggle", function()
	local current_value = vim.diagnostic.is_enabled()
	vim.diagnostic.enable(not current_value)
end, {})

-- Command to toggle semicolon at the end of line
vim.api.nvim_create_user_command("ToggleSemi", function()
	local mode = vim.api.nvim_get_mode().mode
	local pos = vim.api.nvim_win_get_cursor(0)
	local line = vim.api.nvim_get_current_line()
	local col = pos[2]
	local len = #line

	if line:sub(-1) == ";" then
		-- Remove the last semicolon
		vim.api.nvim_set_current_line(line:sub(1, -2))
		if col > len - 1 then
			-- If cursor was at the end (after the semicolon), keep it at the new end
			col = len - 1
		end
	else
		-- Add a semicolon at the end
		vim.api.nvim_set_current_line(line .. ";")
		if col >= len then
			-- If cursor was at the end, move it after the new semicolon
			col = len
		end
	end

	-- Restore cursor position
	vim.api.nvim_win_set_cursor(0, { pos[1], math.max(col, 0) })

	-- If we were in insert mode, return to insert mode
	if mode:sub(1, 1) == "i" then
		vim.cmd("startinsert")
	end
end, {})

m("n", "<Leader>ii", ':lua vim.cmd("DiagnosticsToggleVirtualText")<CR>', { noremap = true, silent = true })
m("n", "<Leader>id", ':lua vim.cmd("DiagnosticsToggle")<CR>', { noremap = true, silent = true })
m({ "n", "i" }, "<C-;>", "<cmd>ToggleSemi<CR>", { noremap = true, silent = true })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
	end,
})

vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/rachartier/tiny-inline-diagnostic.nvim",
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/nvim-mini/mini.hues",
	"https://github.com/nvim-mini/mini.pick",
	"https://github.com/nvim-mini/mini.pairs",
	"https://github.com/nvim-mini/mini.comment",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/stevearc/oil.nvim",
})

vim.cmd("color miniwinter")
require("mini.pairs").setup()
require("mini.pick").setup()
require("oil").setup()

require("lsp")
require("syntax-highlight")
require("diagnostics")
require("autocomplete")
require("format")
require("git")
