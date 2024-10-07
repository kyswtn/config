---@diagnostic disable: param-type-mismatch

local Layout = require("nui.layout")
local Popup = require("nui.popup")

local border = {
  prompt = {
    top_left = "┌",
    top = "─",
    right = "│",
    top_right = "┬",
    bottom_right = "┤",
    bottom = "─",
    bottom_left = "├",
    left = "│",
  },
  -- These patches are not working :(
  prompt_patch = {
    horizontal = {},
    minimal = {},
    vertical = {},
  },
  results = {
    top_left = "",
    top = "",
    top_right = "",
    right = "│",
    bottom_right = "┴",
    bottom = "─",
    bottom_left = "└",
    left = "│",
  },
  results_patch = {
    horizontal = {},
    minimal = {},
    vertical = {},
  },
  preview = {
    top_left = "─",
    top = "─",
    top_right = "┐",
    right = "│",
    bottom_right = "┘",
    bottom = "─",
    bottom_left = "─",
    left = " ",
  },
  preview_patch = {
    horizontal = {},
    minimal = {},
    vertical = {},
  },
}

local create_layout = function(picker)
  local TSLayout = require("telescope.pickers.layout")

  local prompt = Popup({
    enter = true,
    border = {
      style = border.prompt,
    },
    win_options = {
      winhighlight = "Normal:Normal",
    },
  })

  local results = Popup({
    focusable = false,
    border = {
      style = border.results,
    },
    win_options = {
      winhighlight = "Normal:Normal",
    },
  })

  local preview = Popup({
    focusable = false,
    border = {
      style = border.preview,
    },
  })

  local layout_by_kind = {
    horizontal = Layout.Box({
      Layout.Box({
        Layout.Box(prompt, { size = 3 }),
        Layout.Box(results, { grow = 1 }),
      }, { dir = "col", size = "49%" }),
      Layout.Box(preview, { size = "51%" }),
    }, { dir = "row" }),
    vertical = Layout.Box({
      Layout.Box(prompt, { size = 3 }),
      Layout.Box(results, { grow = 1 }),
      Layout.Box(preview, { grow = 1 }),
    }, { dir = "col" }),
    minimal = Layout.Box({
      Layout.Box(prompt, { size = 3 }),
      Layout.Box(results, { grow = 1 }),
    }, { dir = "col" }),
  }

  local size_by_kind = {
    horizontal = {
      width = "90%",
      height = "89%",
    },
    vertical = {
      width = "90%",
      height = "90%",
    },
    minimal = {
      width = "90%",
      height = "90%",
    },
  }

  local function get_box()
    local strategy = picker.layout_strategy
    if strategy == "vertical" or strategy == "horizontal" then
      return layout_by_kind[strategy], strategy
    end

    local height, width = vim.o.lines, vim.o.columns
    local box_kind = "horizontal"
    if width < 100 then
      box_kind = "vertical"
      if height < 40 then
        box_kind = "minimal"
      end
    end
    return layout_by_kind[box_kind], box_kind
  end

  local function prepare_layout_parts(layout, box_type)
    layout.prompt = TSLayout.Window(prompt)
    prompt.border:set_style(vim.tbl_extend("force", border.prompt, border.prompt_patch[box_type]))

    layout.results = TSLayout.Window(results)
    results.border:set_style(vim.tbl_extend("force", border.results, border.results_patch[box_type]))

    if box_type == "minimal" then
      layout.preview = nil
    else
      layout.preview = TSLayout.Window(preview)
      preview.border:set_style(vim.tbl_extend("force", border.preview, border.preview_patch[box_type]))
    end
  end

  local box, box_kind = get_box()
  local layout = Layout({
    relative = "editor",
    size = (size_by_kind)[box_kind],
    position = {
      row = "40%",
      col = "50%",
    },
  }, box)

  prepare_layout_parts(layout, box_kind)

  local layout_update = layout.update
  function layout:update()
    local new_box, new_box_kind = get_box()
    prepare_layout_parts(layout, new_box_kind)

    layout_update(self, { size = (size_by_kind)[box_kind] }, new_box)
  end

  return TSLayout(layout)
end

return create_layout
