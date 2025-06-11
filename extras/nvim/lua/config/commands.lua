-- Added based on code samples from conform's repository.

vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ async = true, lsp_fallback = true, range = range })
end, { range = true })

vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    ---@diagnostic disable-next-line: inject-field
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function()
  ---@diagnostic disable-next-line: inject-field
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})

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

local code_actions = {
  fillarms = "Fill match arms",
  -- Add more custom actions here
}

vim.api.nvim_create_user_command("Action", function(opts)
  local param = opts.args
  local code_action = code_actions[param]
  if not code_action then
    vim.notify("Unknown code action: " .. param, vim.log.levels.ERROR)
    return
  end

  vim.lsp.buf.code_action({
    filter = function(action)
      vim.print(action.title)
      return action.title == code_action
    end,
    apply = true, -- Automatically apply if only one action is available
  })
end, {
  nargs = 1,
  complete = function()
    return vim.tbl_keys(code_actions)
  end,
})
