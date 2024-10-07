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
      }
    end,
  },
}
