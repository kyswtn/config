return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = function()
      return {
        options = {
          theme = "auto",
          section_separators = "",
          component_separators = "",
        },
        sections = {
          lualine_a = {
            "mode",
          },
          lualine_b = {
            { "branch", icon = { "", align = "left" } },
            "diff",
            "diagnostics",
          },
          lualine_c = { "filename" },
          lualine_x = { "encoding" },
          lualine_y = {},
          lualine_z = {
            "location",
          },
        },
      }
    end,
  },
}
