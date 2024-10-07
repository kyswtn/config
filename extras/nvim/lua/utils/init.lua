local M = {}

M.run_command = function(command, args, cwd)
  local Job = require("plenary.job")
  local stderr = {}
  local stdout, ret = Job:new({
    command = command,
    args = args,
    cwd = cwd or vim.loop.cwd(),
    on_stderr = function(_, data)
      table.insert(stderr, data)
    end,
  }):sync()
  return stdout, ret, stderr
end

M.in_a_git_repo = function()
  local in_worktree = M.run_command("git", { "rev-parse", "--is-inside-work-tree" })
  return in_worktree[1] ~= "true"
end

M.get_git_root = function()
  local dot_git_path = vim.fn.finddir(".git", ".;")
  return vim.fn.fnamemodify(dot_git_path, ":h")
end

M.call_telescope = function(cmd, opts)
  return function()
    local telescope = require("telescope.builtin")

    if cmd == "git_files" then
      local in_a_git_repo = M.in_a_git_repo()
      if not in_a_git_repo then
        cmd = "find_files"
      end
    end

    telescope[cmd](opts)
  end
end

-- Copied from lazyvim source code.
-- https://github.com/LazyVim/LazyVim/blob/879e29504d43e9f178d967ecc34d482f902e5a91/lua/lazyvim/util/init.lua#L146-L169
function M.safe_keymap_set(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  local modes = type(mode) == "string" and { mode } or mode

  ---@param m string
  modes = vim.tbl_filter(function(m)
    return not (keys.have and keys:have(lhs, m))
  end, modes)

  -- Do not create the keymap if a lazy keys handler exists.
  if #modes > 0 then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      ---@diagnostic disable-next-line: no-unknown
      opts.remap = nil
    end
    vim.keymap.set(modes, lhs, rhs, opts)
  end
end

return M
