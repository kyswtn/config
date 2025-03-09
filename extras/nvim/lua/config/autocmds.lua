local function augroup(name)
  return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argv(0) == "" or vim.fn.argv(0) == "." then
      require("telescope.builtin").find_files()
    end
  end,
})

-- Disable semantic token to prevent flashing.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
  group = augroup("lsp"),
})

-- Hide previous command outputs after 5s.
vim.api.nvim_create_autocmd("CmdlineLeave", {
  callback = function()
    vim.fn.timer_start(5000, function()
      print(" ")
    end)
  end,
  group = augroup("cmdline"),
})

-- Setup linter.
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
  group = augroup("linter"),
})

-- Custom file type associations.
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "flake.lock",
  callback = function()
    vim.cmd("set filetype=json")
  end,
  group = augroup("filetypedetect"),
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.zon",
  callback = function()
    vim.cmd("set filetype=zig")
  end,
  group = augroup("filetypedetect"),
})

-- Set shiftwidth and tabstop for *.go files.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
  group = augroup("filetype"),
})
