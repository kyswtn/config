local opt = vim.opt

-- Syntax highlighting.
opt.termguicolors = true -- True color support.

-- Line numbers.
opt.relativenumber = true -- Use relative line numbers.
opt.number = true -- Show current line number instead of 0.

-- Folding.
opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
opt.foldcolumn = "0"
opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value.
opt.foldlevelstart = 99
opt.foldenable = true

-- Aesthetics.
opt.laststatus = 3 -- Only use 1 shared status bar.
opt.splitbelow = true -- Horizontal splits open to the bottom.
opt.splitright = true -- Vertical splits open to the right.
opt.cursorline = true -- Highlight current line.
opt.signcolumn = "yes:1" -- Don't hide sign column (column before numbers line) by default.
-- opt.colorcolumn = "100" -- Add a ruler at print width 100. Shoutout to TIGER_STYLE by tigerbeetle.

-- Indentation.
opt.expandtab = true -- Use spaces instead of tabs.
opt.smartindent = true -- Insert indents automatically.
opt.shiftround = true -- not sure what this does; but it's required to make indents work.
opt.shiftwidth = 2 -- Numbers of spaces to insert when indented by like enter key.
opt.tabstop = 2 -- Number of spaces tabs count for.

-- Niceties.
opt.clipboard = "unnamedplus" -- Use system clipboard.
opt.ignorecase = true -- Ignore case when searching; use `\C` to force not doing that.
opt.smartcase = true -- Don't ignore case if search pattern has uppercase.

-- Disable autoformat initially.
vim.b.disable_autoformat = true
vim.g.disable_autoformat = true
