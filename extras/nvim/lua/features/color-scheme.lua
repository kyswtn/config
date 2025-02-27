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
      -- vim.cmd.colorscheme("no-clown-fiesta")
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
        variant = "main",
        styles = {
          transparency = true,
        },
      })
    end,
    init = function()
      vim.cmd("set background=dark")
      vim.cmd.colorscheme("rose-pine")
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
      -- vim.cmd("set background=light")
      -- vim.cmd.colorscheme("tokyonight")
    end,
  },
  {
    "sainnhe/gruvbox-material",
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_enable_italic = false
      vim.g.gruvbox_material_transparent_background = true
      -- vim.cmd("set background=dark")
      -- vim.cmd.colorscheme("gruvbox-material")
    end,
  },
  {
    "kepano/flexoki-neovim",
    name = "flexoki",
    enabled = true,
    lazy = false,
    config = function()
      -- vim.cmd("set background=light")
      -- vim.cmd.colorscheme("flexoki-light")
    end,
  },
}
