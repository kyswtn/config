return {
  {
    "folke/which-key.nvim",
    enabled = false,
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 100
    end,
    opts = {
      show_help = false,
      icons = {
        separator = "",
      },
      win = {
        border = "single",
        margin = { 1, 0, 1, 0.6 },
        padding = { 0, 0, 0, 0 },
        winblend = 0,
      },
      layout = {
        height = { min = 4, max = 75 },
        width = { min = 10, max = 50 },
      },
    },
  },
}
