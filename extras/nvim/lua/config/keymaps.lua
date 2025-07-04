local utils = require("utils")
local map = utils.safe_keymap_set

-- Move to window using the <ctrl> hjkl keys.
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys.
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines.
map("n", "<A-J>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-K>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-J>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-K>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-J>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-K>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- <option> delete to delete a word in insert mode.
map("i", "<A-BS>", "<C-w>", { desc = "Delete word before cursor", remap = true })

-- Better indent.
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Fuzzy finders.
map("n", "<leader>f", utils.call_telescope("find_files", {}), { desc = "Open file picker" })
map("n", "<leader>F", utils.call_telescope("git_files", {}), { desc = "Open file picker (cwd)" })
map("n", "<leader>b", utils.call_telescope("buffers"), { desc = "Open buffer picker" })
map("n", "<leader>h", utils.call_telescope("help_tags"), { desc = "Open help tags" })
map("n", "<leader>/", utils.call_telescope("live_grep"), { desc = "Find in files" })
map("n", "gW", utils.call_telescope("grep_string"), { desc = "Search word under cursor (cwd)" })

-- LSP actions.
map("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename item" })
map("n", "<leader>k", vim.lsp.buf.hover, { desc = "Show docs for item under cursor" })
map("n", "<leader>a", vim.lsp.buf.code_action, { desc = "Perform code action" })

-- Search.
map("n", "<leader>s", ":%s/", { desc = "Search and replace file" })
map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Terminal. By the way does anyone actually remembers <C-\\><C-n>?
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Escape from terminal to normal mode" })

-- Keybinding to toggle inline diagnostics
map("n", "<Leader>ii", ':lua vim.cmd("DiagnosticsToggleVirtualText")<CR>', { noremap = true, silent = true })
map("n", "<Leader>id", ':lua vim.cmd("DiagnosticsToggle")<CR>', { noremap = true, silent = true })

-- Keybinding to toggle checkboxes
map("n", "<C-space>", ":lua require('toggle-checkbox').toggle()<CR>")

-- Keybinding to add semicolon to the end of the line.
map({ "n", "i" }, "<C-;>", "<cmd>ToggleSemi<CR>", { noremap = true, silent = true })
