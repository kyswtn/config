-- Turn default syntax highlighting off and use treesitter's.
vim.cmd("syntax off")

vim.o.clipboard = "unnamedplus"
local function paste()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end

-- Enable OSC 52 on Linux.
if vim.uv.os_uname().sysname == "Linux" then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = paste,
      ["*"] = paste,
    },
  }
end
