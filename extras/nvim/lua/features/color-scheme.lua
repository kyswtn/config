return {
  -- Color Schemes.
  {
    "aktersnurra/no-clown-fiesta.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
    },
    init = function()
      vim.cmd.colorscheme("no-clown-fiesta")
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        variant = "dawn",
        styles = {
          transparency = true,
        },
      })
    end,
    init = function()
      -- vim.cmd.colorscheme("rose-pine")
    end,
  },
  {
    "folke/tokyonight.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    opts = {
      style = "day",
      light_style = "day",
      transparent = true,
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
        functions = { italic = false },
        variables = { italic = false },
      },
    },
    init = function()
      -- vim.cmd.colorscheme("tokyonight")
    end,
  },
}
